//
//  OllamaService.swift
//  Intervene
//
//  Created by Shubhayan Srivastava on 4/12/25.
//

import Foundation
import Combine

// Response model for Ollama API
struct OllamaResponse: Codable {
    let model: String
    let created_at: String
    let message: OllamaMessage
    let done: Bool
    
    // Optional fields that may be present in final response
    let total_duration: Int?
    let load_duration: Int?
    let prompt_eval_count: Int?
    let prompt_eval_duration: Int?
    let eval_count: Int?
    let eval_duration: Int?
}

// Message model
struct OllamaMessage: Codable {
    let role: String
    let content: String
}

// Request model for Ollama API
struct OllamaRequest: Encodable {
    let model: String
    let messages: [OllamaMessage]
    let stream: Bool
    let options: OllamaOptions?
    
    init(model: String, messages: [OllamaMessage], stream: Bool = false, options: OllamaOptions? = nil) {
        self.model = model
        self.messages = messages
        self.stream = stream
        self.options = options
    }
}

// Options for Ollama request
struct OllamaOptions: Encodable {
    let temperature: Float?
    let num_predict: Int?
    
    init(temperature: Float? = 0.7, num_predict: Int? = 1024) {
        self.temperature = temperature
        self.num_predict = num_predict
    }
}

// Error types
enum OllamaServiceError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case apiError(String)
    case notRunning
    case unknownError
}

class OllamaService {
    private let baseURL: String
    private let defaultModel: String
    private var cancellables = Set<AnyCancellable>()
    
    init(baseURL: String = "http://localhost:11434", defaultModel: String = "llama3.2") {
        self.baseURL = baseURL
        self.defaultModel = defaultModel
    }
    
    // Check if Ollama is running
    func checkStatus() -> AnyPublisher<Bool, OllamaServiceError> {
        guard let url = URL(string: "\(baseURL)/api/tags") else {
            return Fail(error: OllamaServiceError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Bool in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw OllamaServiceError.unknownError
                }
                print(httpResponse)
                
                if httpResponse.statusCode == 200 {
                    return true
                } else {
                    throw OllamaServiceError.apiError("Status code: \(httpResponse.statusCode)")
                }
            }
            .mapError { error -> OllamaServiceError in
                if let error = error as? OllamaServiceError {
                    return error
                }
                return OllamaServiceError.networkError(error)
            }
            .eraseToAnyPublisher()
    }
    
    // Generate steps based on user prompt
    func generateSteps(from userPrompt: String) -> AnyPublisher<[String], OllamaServiceError> {
        // System prompt to guide the model to generate steps
        let systemPrompt = """
        You are an AI assistant that helps users accomplish tasks by breaking them down into clear, executable steps.
        When given a task by the user, generate 4-6 concise steps that describe how to accomplish it.
        Each step should be a simple, actionable sentence.
        Return ONLY the numbered steps with no extra text or explanation.
        """
        
        // Create the messages array
//        print("AHAHAHHAHHA I CANNOT DO THIS ANYMORE")
        let messages: [OllamaMessage] = [
            OllamaMessage(role: "system", content: systemPrompt),
            OllamaMessage(role: "user", content: userPrompt)
        ]
        
        // Create the request
        return sendRequest(messages: messages)
            .map { response -> [String] in
                // Parse the response content into steps
                let content = response.message.content.trimmingCharacters(in: .whitespacesAndNewlines)
                let lines = content.split(separator: "\n").map { String($0) }
                
                // Process the lines to extract steps
                var steps: [String] = []
                for line in lines {
                    let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // Skip empty lines
                    if trimmedLine.isEmpty { continue }
                    
                    // Try to extract a step (remove number and dot at beginning)
                    let stepPattern = #"^\s*\d+\.\s*(.*)"#
                    if let match = trimmedLine.range(of: stepPattern, options: .regularExpression) {
                        let stepText = trimmedLine[match].trimmingCharacters(in: .whitespacesAndNewlines)
                        steps.append(stepText)
                    } else {
                        // If no number pattern found, just add the line as is
                        steps.append(trimmedLine)
                    }
                }
                return steps
            }
            .eraseToAnyPublisher()
    }
    
    // Respond to user feedback or refinements
    func refineSteps(currentSteps: [String], userFeedback: String) -> AnyPublisher<[String], OllamaServiceError> {
        // Create a formatted list of current steps
        let stepsString = currentSteps.enumerated().map { i, step in
            return "\(i+1). \(step)"
        }.joined(separator: "\n")
        
        // System prompt for refinement
        let systemPrompt = """
        You are an AI assistant that helps refine task steps based on user feedback.
        Review the current steps and the user's feedback, then provide an updated list of 4-6 steps.
        Each step should be a simple, actionable sentence.
        Return ONLY the numbered steps with no extra text or explanation.
        """
        
        // User prompt combining current steps and feedback
        let userPrompt = """
        Current steps:
        \(stepsString)
        
        My feedback:
        \(userFeedback)
        
        Please update the steps based on my feedback.
        """
        
        // Create the messages array
        let messages: [OllamaMessage] = [
            OllamaMessage(role: "system", content: systemPrompt),
            OllamaMessage(role: "user", content: userPrompt)
        ]
        
        // Create the request
        return sendRequest(messages: messages)
            .map { response -> [String] in
                // Parse the response content into steps (same logic as generateSteps)
                let content = response.message.content.trimmingCharacters(in: .whitespacesAndNewlines)
                let lines = content.split(separator: "\n").map { String($0) }
                
                var steps: [String] = []
                for line in lines {
                    let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmedLine.isEmpty { continue }
                    
                    let stepPattern = #"^\s*\d+\.\s*(.*)"#
                    if let range = trimmedLine.range(of: stepPattern, options: .regularExpression) {
                        let stepStart = trimmedLine.index(range.lowerBound, offsetBy: 3)
                        if stepStart < trimmedLine.endIndex {
                            let stepText = String(trimmedLine[stepStart...]).trimmingCharacters(in: .whitespacesAndNewlines)
                            steps.append(stepText)
                        }
                    } else {
                        steps.append(trimmedLine)
                    }
                }
                
                return steps
            }
            .eraseToAnyPublisher()
    }
    
    // Generic method to send requests to Ollama
    private func sendRequest(messages: [OllamaMessage]) -> AnyPublisher<OllamaResponse, OllamaServiceError> {
        guard let url = URL(string: "\(baseURL)/api/chat") else {
            return Fail(error: OllamaServiceError.invalidURL).eraseToAnyPublisher()
        }
        
        // Create the request
        let request = OllamaRequest(
            model: defaultModel,
            messages: messages,
            options: OllamaOptions(temperature: 0.7)
        )
        
        // Convert to JSON
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            return Fail(error: OllamaServiceError.decodingError(error)).eraseToAnyPublisher()
        }
        
        // Send the request
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw OllamaServiceError.unknownError
                }
                
                if httpResponse.statusCode == 200 {
                    return data
                } else {
                    let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                    throw OllamaServiceError.apiError("API error: \(errorMessage)")
                }
            }
            .decode(type: OllamaResponse.self, decoder: JSONDecoder())
            .mapError { error -> OllamaServiceError in
                if let error = error as? OllamaServiceError {
                    return error
                } else if let error = error as? DecodingError {
                    return OllamaServiceError.decodingError(error)
                }
                return OllamaServiceError.networkError(error)
            }
            .eraseToAnyPublisher()
    }
}
