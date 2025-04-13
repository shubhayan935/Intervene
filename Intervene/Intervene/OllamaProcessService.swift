//
//  OllamaProcessService.swift
//  Intervene
//
//  Created by Shubhayan Srivastava on 4/12/25.
//

import Foundation
import Combine

class OllamaProcessService {
    private let defaultModel: String
    
    init(defaultModel: String = "llama3.2") {
        self.defaultModel = defaultModel
    }
    
    // Check if Ollama is running
    func checkStatus() -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/curl")
            process.arguments = ["-s", "http://127.0.0.1:11434/api/version"]
            
            let pipe = Pipe()
            process.standardOutput = pipe
            
            do {
                try process.run()
                process.waitUntilExit()
                
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8), !output.isEmpty {
                    print("Ollama is running: \(output)")
                    promise(.success(true))
                } else {
                    print("No output from Ollama")
                    promise(.success(false))
                }
            } catch {
                print("Error checking Ollama status: \(error)")
                promise(.success(false))  // Not treating this as an error, just indicating Ollama isn't available
            }
        }.eraseToAnyPublisher()
    }
    
    // Generate steps based on user prompt
    func generateSteps(from userPrompt: String) -> AnyPublisher<[String], Error> {
        return Future<[String], Error> { promise in
            // Create the system prompt
            let systemPrompt = """
            You are an AI assistant that helps users accomplish tasks by breaking them down into clear, executable steps.
            When given a task by the user, generate 4-6 concise steps that describe how to accomplish it.
            Each step should be a simple, actionable sentence.
            Return ONLY the numbered steps with no extra text or explanation.
            """
            
            // Create the full prompt
            let fullPrompt = """
            System: \(systemPrompt)
            
            User: \(userPrompt)
            
            Assistant:
            """
            
            // Create a temporary file for the prompt
            let tempPromptURL = FileManager.default.temporaryDirectory.appendingPathComponent("ollama_prompt_\(UUID().uuidString).txt")
            do {
                try fullPrompt.write(to: tempPromptURL, atomically: true, encoding: .utf8)
                
                // Execute Ollama with the prompt file
                let process = Process()
                process.executableURL = URL(fileURLWithPath: "/usr/bin/curl")
                process.arguments = [
                    "-s",
                    "http://127.0.0.1:11434/api/chat",
                    "-d",
                    "{ \"model\": \"\(self.defaultModel)\", \"messages\": [{ \"role\": \"system\", \"content\": \"\(systemPrompt.replacingOccurrences(of: "\"", with: "\\\""))\" }, { \"role\": \"user\", \"content\": \"\(userPrompt.replacingOccurrences(of: "\"", with: "\\\""))\" }] }"
                ]
                
                let pipe = Pipe()
                process.standardOutput = pipe
                
                try process.run()
                process.waitUntilExit()
                
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8), !output.isEmpty {
                    // Parse response
                    if let jsonData = output.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                       let message = json["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        
                        // Parse the content into steps
                        let lines = content.split(separator: "\n").map { String($0) }
                        var steps: [String] = []
                        
                        for line in lines {
                            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                            if trimmedLine.isEmpty { continue }
                            
                            // Try to extract steps (remove number prefix if present)
                            if let range = trimmedLine.range(of: #"^\s*\d+\.\s*(.*)"#, options: .regularExpression) {
                                let startIndex = trimmedLine.index(range.lowerBound, offsetBy: 3)
                                if startIndex < trimmedLine.endIndex {
                                    let stepText = String(trimmedLine[startIndex...]).trimmingCharacters(in: .whitespacesAndNewlines)
                                    steps.append(stepText)
                                }
                            } else {
                                steps.append(trimmedLine)
                            }
                        }
                        
                        promise(.success(steps))
                    } else {
                        promise(.failure(NSError(domain: "OllamaProcessError", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Failed to parse Ollama response: \(output)"])))
                    }
                } else {
                    promise(.failure(NSError(domain: "OllamaProcessError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "No output from Ollama"])))
                }
                
                // Clean up
                try? FileManager.default.removeItem(at: tempPromptURL)
                
            } catch {
                print("Error generating steps: \(error)")
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    // Refine steps based on user feedback
    func refineSteps(currentSteps: [String], userFeedback: String) -> AnyPublisher<[String], Error> {
        return Future<[String], Error> { promise in
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
            
            // Create the full prompt JSON
            let messagesJson = """
            {
              "model": "\(self.defaultModel)",
              "messages": [
                { "role": "system", "content": "\(systemPrompt.replacingOccurrences(of: "\"", with: "\\\""))" },
                { "role": "user", "content": "\(userPrompt.replacingOccurrences(of: "\"", with: "\\\""))" }
              ]
            }
            """
            
            // Create a temporary file for the JSON
            let tempJsonURL = FileManager.default.temporaryDirectory.appendingPathComponent("ollama_request_\(UUID().uuidString).json")
            do {
                try messagesJson.write(to: tempJsonURL, atomically: true, encoding: .utf8)
                
                // Execute Ollama with the prompt
                let process = Process()
                process.executableURL = URL(fileURLWithPath: "/usr/bin/curl")
                process.arguments = [
                    "-s",
                    "http://127.0.0.1:11434/api/chat",
                    "-d", "@\(tempJsonURL.path)"
                ]
                
                let pipe = Pipe()
                process.standardOutput = pipe
                
                try process.run()
                process.waitUntilExit()
                
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8), !output.isEmpty {
                    // Parse response - same logic as in generateSteps
                    if let jsonData = output.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                       let message = json["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        
                        // Parse the content into steps (same logic as in generateSteps)
                        let lines = content.split(separator: "\n").map { String($0) }
                        var steps: [String] = []
                        
                        for line in lines {
                            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                            if trimmedLine.isEmpty { continue }
                            
                            if let range = trimmedLine.range(of: #"^\s*\d+\.\s*(.*)"#, options: .regularExpression) {
                                let startIndex = trimmedLine.index(range.lowerBound, offsetBy: 3)
                                if startIndex < trimmedLine.endIndex {
                                    let stepText = String(trimmedLine[startIndex...]).trimmingCharacters(in: .whitespacesAndNewlines)
                                    steps.append(stepText)
                                }
                            } else {
                                steps.append(trimmedLine)
                            }
                        }
                        
                        promise(.success(steps))
                    } else {
                        promise(.failure(NSError(domain: "OllamaProcessError", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Failed to parse Ollama response"])))
                    }
                } else {
                    promise(.failure(NSError(domain: "OllamaProcessError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "No output from Ollama"])))
                }
                
                // Clean up
                try? FileManager.default.removeItem(at: tempJsonURL)
                
            } catch {
                print("Error refining steps: \(error)")
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
