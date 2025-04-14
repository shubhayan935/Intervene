//
//  StepsExecutionService.swift
//  Intervene
//
//  Created by Shubhayan Srivastava on 4/12/25.
//

import Foundation
import Combine

// Models for API communication
struct StepsExecutionRequest: Encodable {
    let steps: [String]
}

struct StepUpdate: Decodable {
    let completedStepIndex: Int
    let message: String?
}

enum StepsExecutionError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case apiError(String, Int)
    case webSocketError(Error)
    case unknownError
}

class StepsExecutionService {
    private let baseURL: String
    private var webSocketTask: URLSessionWebSocketTask?
    private var stepUpdateSubject = PassthroughSubject<StepUpdate, StepsExecutionError>()
    
    init(baseURL: String = "http://localhost:8000") {
        self.baseURL = baseURL
    }
    
    // Send steps to backend for execution
    func executeSteps(_ steps: [String]) -> AnyPublisher<Bool, StepsExecutionError> {
        guard let url = URL(string: "\(baseURL)/steps") else {
            return Fail(error: StepsExecutionError.invalidURL).eraseToAnyPublisher()
        }
        
        let requestBody = StepsExecutionRequest(steps: steps)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            return Fail(error: StepsExecutionError.decodingError(error)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response -> Bool in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw StepsExecutionError.unknownError
                }
                
                if (200...299).contains(httpResponse.statusCode) {
                    return true
                } else {
                    let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                    throw StepsExecutionError.apiError(errorMessage, httpResponse.statusCode)
                }
            }
            .mapError { error -> StepsExecutionError in
                if let error = error as? StepsExecutionError {
                    return error
                }
                return StepsExecutionError.networkError(error)
            }
            .eraseToAnyPublisher()
    }
    
    // Connect to WebSocket for real-time execution updates
    func connectToStepUpdates() -> AnyPublisher<StepUpdate, StepsExecutionError> {
        // Disconnect any existing connection
        disconnectFromStepUpdates()
        
        guard let url = URL(string: "ws://\(baseURL.replacingOccurrences(of: "http://", with: ""))/step-updates") else {
            return Fail(error: StepsExecutionError.invalidURL).eraseToAnyPublisher()
        }
        
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        
        // Start receiving messages
        receiveMessage()
        
        return stepUpdateSubject.eraseToAnyPublisher()
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    if let data = text.data(using: .utf8) {
                        do {
                            let stepUpdate = try JSONDecoder().decode(StepUpdate.self, from: data)
                            self?.stepUpdateSubject.send(stepUpdate)
                        } catch {
                            self?.stepUpdateSubject.send(completion: .failure(.decodingError(error)))
                        }
                    }
                case .data(let data):
                    do {
                        let stepUpdate = try JSONDecoder().decode(StepUpdate.self, from: data)
                        self?.stepUpdateSubject.send(stepUpdate)
                    } catch {
                        self?.stepUpdateSubject.send(completion: .failure(.decodingError(error)))
                    }
                @unknown default:
                    self?.stepUpdateSubject.send(completion: .failure(.unknownError))
                }
                
                // Continue receiving messages
                self?.receiveMessage()
                
            case .failure(let error):
                self?.stepUpdateSubject.send(completion: .failure(.webSocketError(error)))
            }
        }
    }
    
    func disconnectFromStepUpdates() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
    }
}
