//
//  BackendManager.swift
//  Intervene
//
//  Created by Shubhayan Srivastava on 4/18/25.
//

import Foundation
import Combine

class BackendManager {
    static let shared = BackendManager()
    private var process: Process?
    private var isRunning = false
    private var cancellables = Set<AnyCancellable>()
    
    private var backendExecutablePath: String? {
        let possiblePaths = [
            Bundle.main.path(forResource: "backend", ofType: ""),
            Bundle.main.path(forResource: "backend", ofType: ".exe"),
            Bundle.main.path(forResource: "backend", ofType: ".bin")
        ]
        
        print("Searching for backend executable in:")
        possiblePaths.forEach { path in
            if let path = path {
                print("- \(path) (exists: \(FileManager.default.fileExists(atPath: path)))")
            }
        }
        
        return possiblePaths.compactMap { $0 }.first(where: { FileManager.default.fileExists(atPath: $0) })
    }
    
    private init() {
        // Private initializer for singleton pattern
    }
    
    func testRunBackendDirectly() {
        guard let backendPath = backendExecutablePath else {
            print("Backend executable not found")
            return
        }
        
        print("Testing backend directly: \(backendPath)")
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: backendPath)
        
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        let errorPipe = Pipe()
        process.standardError = errorPipe
        
        do {
            try process.run()
            
            // Wait for a bit and capture output
            DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) {
                let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
                let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
                
                if let output = String(data: outputData, encoding: .utf8), !output.isEmpty {
                    print("Backend direct output: \(output)")
                }
                
                if let error = String(data: errorData, encoding: .utf8), !error.isEmpty {
                    print("Backend direct error: \(error)")
                }
                
                process.terminate()
            }
        } catch {
            print("Failed to test backend directly: \(error)")
        }
    }
    
    func startBackend() -> AnyPublisher<Bool, Error> {
//        testRunBackendDirectly()
        print("starting backend")
        return Future<Bool, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "BackendManager", code: 1000, userInfo: [NSLocalizedDescriptionKey: "Self reference lost"])))
                return
            }
            
            // Check if backend is already running
            if self.isRunning {
                promise(.success(true))
                return
            }
            
            // Get path to the backend executable
            guard let backendPath = self.backendExecutablePath else {
                let error = NSError(domain: "BackendManager", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Backend executable not found in bundle"])
                print("Error: \(error.localizedDescription)")
                promise(.failure(error))
                return
            }
            
            do {
                // Print the exact path for debugging
                print("Setting permissions for: \(backendPath)")
                try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: backendPath)
                print("Set executable permissions for backend")
            } catch {
                print("Warning: Failed to set executable permissions: \(error)")
                // Continue anyway as it might already be executable
            }
            
            // Create and configure the process
            let process = Process()
            process.executableURL = URL(fileURLWithPath: backendPath)
            
            // Configure the process environment
            process.environment = ProcessInfo.processInfo.environment
            
            // Set the current directory to the Resources folder
            if let resourcePath = Bundle.main.resourcePath {
                process.currentDirectoryURL = URL(fileURLWithPath: resourcePath)
            }
            
            // Redirect output to pipes for logging
            let outputPipe = Pipe()
            let errorPipe = Pipe()
            process.standardOutput = outputPipe
            process.standardError = errorPipe
            
            // Setup monitoring for output and errors
            outputPipe.fileHandleForReading.readabilityHandler = { fileHandle in
                let data = fileHandle.availableData
                if !data.isEmpty, let output = String(data: data, encoding: .utf8) {
                    print("Backend output: \(output)")
                }
            }
            
            errorPipe.fileHandleForReading.readabilityHandler = { fileHandle in
                let data = fileHandle.availableData
                if !data.isEmpty, let output = String(data: data, encoding: .utf8) {
                    print("Backend error: \(output)")
                }
            }
            
            // Setup completion handler
            process.terminationHandler = { [weak self] process in
                self?.isRunning = false
                print("Backend process terminated with status: \(process.terminationStatus)")
                
                // Cleanup file handles
                outputPipe.fileHandleForReading.readabilityHandler = nil
                errorPipe.fileHandleForReading.readabilityHandler = nil
            }
            
            // Start the process
            do {
                try process.run()
                self.process = process
                self.isRunning = true
                
                // Give the backend a moment to start up
                DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
                    // Check if the backend API is responding
                    self.checkBackendStatus()
                        .receive(on: DispatchQueue.main)
                        .sink(
                            receiveCompletion: { completion in
                                if case .failure(let error) = completion {
                                    promise(.failure(error))
                                }
                            },
                            receiveValue: { isResponding in
                                promise(.success(isResponding))
                            }
                        )
                        .store(in: &self.cancellables)
                }
            } catch {
                print("Failed to start backend: \(error)")
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func stopBackend() {
        if let process = process, process.isRunning {
            process.terminate()
            isRunning = false
            print("Backend process terminated")
        }
    }
    
    private func checkBackendStatus() -> AnyPublisher<Bool, Error> {
        // This assumes your FastAPI backend has a health check endpoint
        guard let url = URL(string: "http://localhost:8000/health") else {
            return Fail(error: NSError(domain: "BackendManager", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .timeout(.seconds(5), scheduler: DispatchQueue.global())
            .tryMap { data, response -> Bool in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NSError(domain: "BackendManager", code: 1003, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                }
                
                return (200...299).contains(httpResponse.statusCode)
            }
            .catch { error -> AnyPublisher<Bool, Error> in
                print("Backend status check failed: \(error)")
                return Just(false)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
