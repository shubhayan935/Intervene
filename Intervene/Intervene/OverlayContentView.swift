//
//  OverlayContentView.swift
//  Intervene
//
//  Created by Shubhayan Srivastava on 4/12/25.
//

import Foundation
import SwiftUI
import Combine

// Define message types for the chat interface
enum MessageType {
    case userMessage(String)
    case agentSteps([String])
    case error(String)
}

// Message model for the chat
struct ChatMessage: Identifiable {
    let id = UUID()
    let type: MessageType
    let timestamp = Date()
}

// Define the view states
enum OverlayViewState {
    case chat
    case executing
}

struct OverlayContentView: View {
    // Callback to dismiss the overlay
    var closeOverlay: () -> Void
    // Callback to send the confirmed steps to the backend
    var sendConfirmation: (_ steps: [String]) -> Void
    
    // MARK: - Services
    private let ollamaService = OllamaService()
    
    // MARK: - State Properties
    @State private var userPrompt: String = ""
    @State private var chatMessages: [ChatMessage] = []
    @State private var isLoading: Bool = false
    @State private var viewState: OverlayViewState = .chat
    @State private var currentExecutingStep: Int = 0
    @State private var executingSteps: [String] = []
    @State private var scrollID = UUID()
    @State private var cancellables = Set<AnyCancellable>()
    @State private var ollamaAvailable: Bool = false
    
    // Derived state for the latest agent steps
    private var latestAgentSteps: [String]? {
        if let lastAgentMessage = chatMessages.last(where: {
            if case .agentSteps(_) = $0.type { return true }
            return false
        }) {
            if case let .agentSteps(steps) = lastAgentMessage.type {
                return steps
            }
        }
        return nil
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header with title
                HStack {
                    Text(viewState == .chat ? "Agent Assistant" : "Executing Steps")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    
                    // Ollama status indicator
                    if ollamaAvailable {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                    } else {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                    }
                    
                    // Close button
                    Button(action: closeOverlay) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.black.opacity(0.7))
                
                if viewState == .chat {
                    simpleChatView
                } else {
                    executingView
                }
            }
            .frame(width: 350, height: 450)
            .cornerRadius(12)
            .shadow(radius: 6)
            .onAppear {
                checkOllamaStatus()
            }
        }
    }
    
    // MARK: - Simple Chat View
    private var simpleChatView: some View {
        VStack(spacing: 0) {
            // Chat messages
            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(chatMessages) { message in
                            VStack(spacing: 0) {
                                // Message content
                                Group {
                                    switch message.type {
                                    case .userMessage(let text):
                                        // User message - right aligned
                                        HStack {
                                            Spacer()
                                            Text(text)
                                                .font(.system(size: 14))
                                                .foregroundColor(.white)
                                                .lineLimit(nil)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                        }
                                        
                                    case .agentSteps(let steps):
                                        // Agent message - left aligned
                                        VStack(alignment: .leading, spacing: 8) {
                                            ForEach(steps.indices, id: \.self) { index in
                                                Text("\(index + 1). \(steps[index])")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 14))
                                                    .lineLimit(nil)
                                                    .fixedSize(horizontal: false, vertical: true)
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                    case .error(let errorMessage):
                                        // Error message
                                        HStack {
                                            Image(systemName: "exclamationmark.triangle")
                                                .foregroundColor(.yellow)
                                            
                                            Text(errorMessage)
                                                .font(.system(size: 14))
                                                .foregroundColor(.red)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    }
                                }
                                
                                // Divider after each message
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 1)
                                    .padding(.vertical, 4)
                            }
                            .id(message.id)
                        }
                        
                        // For automatic scrolling
                        Color.clear.frame(height: 1).id(scrollID)
                        
                        if isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.7)
                                Spacer()
                            }
                            .padding()
                        }
                    }
                }
                .onChange(of: scrollID) { oldValue, newValue in
                    scrollToBottom(proxy: scrollProxy)
                }
            }
            .background(Color.black)
            
            // Show Intervene button if we have agent steps
            if let steps = latestAgentSteps, !steps.isEmpty {
                Button(action: {
                    executingSteps = steps
                    currentExecutingStep = 0
                    viewState = .executing
                    // Start the execution process
                    sendConfirmation(steps)
                }) {
                    Text("Intervene")
                        .font(.headline)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            
            // Input area with Ollama warning if not available
            VStack(spacing: 8) {
                if !ollamaAvailable {
                    Text("Ollama not detected. Make sure it's running.")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 16)
                }
                
                HStack {
                    TextField("Enter instruction...", text: $userPrompt)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(isLoading || !ollamaAvailable)
                        .onSubmit {
                            sendMessage()
                        }
                    
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(userPrompt.isEmpty || isLoading || !ollamaAvailable ? .gray : .blue)
                    }
                    .disabled(userPrompt.isEmpty || isLoading || !ollamaAvailable)
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .background(Color.black.opacity(0.7))
        }
    }
    
    // MARK: - Executing View
    private var executingView: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title and progress
            HStack {
                Text("Executing \(currentExecutingStep + 1) of \(executingSteps.count) steps")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                Spacer()
                
                // Loading indicator for current step
                if currentExecutingStep < executingSteps.count {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.7)
                }
            }
            .padding(.horizontal, 8)
            
            // Steps list
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(executingSteps.indices, id: \.self) { index in
                        HStack(alignment: .top, spacing: 12) {
                            // Status indicator
                            ZStack {
                                Circle()
                                    .fill(statusColor(for: index))
                                    .frame(width: 20, height: 20)
                                
                                if index < currentExecutingStep {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                } else if index == currentExecutingStep {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.5)
                                }
                            }
                            
                            Text(executingSteps[index])
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.leading)
                        }
                        
                        if index < executingSteps.count - 1 {
                            Divider()
                                .background(Color.gray.opacity(0.3))
                                .padding(.leading, 32)
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
            
            // Return to chat button (when all steps are complete)
            if currentExecutingStep >= executingSteps.count {
                Button(action: {
                    viewState = .chat
                }) {
                    Text("Return to Chat")
                        .font(.headline)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            } else {
                // Simulate step execution
                Text("Running: \(executingSteps[currentExecutingStep])")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
        }
        .padding(.top, 8)
        .onAppear {
            simulateExecution()
        }
    }
    
    // MARK: - Methods
    
    private func checkOllamaStatus() {
        ollamaService.checkStatus()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(_) = completion {
                        self.ollamaAvailable = false
                    }
                },
                receiveValue: { isAvailable in
                    self.ollamaAvailable = isAvailable
                }
            )
            .store(in: &cancellables)
    }
    
    private func sendMessage() {
        guard !userPrompt.isEmpty && !isLoading && ollamaAvailable else { return }
        
        let message = userPrompt.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Add user message to chat
        chatMessages.append(ChatMessage(type: .userMessage(message)))
        
        // Clear the prompt
        userPrompt = ""
        isLoading = true
        
        // Update scroll position
        scrollID = UUID()
        
        // Check if we have previous agent steps (for refinement)
        if let lastSteps = latestAgentSteps, !lastSteps.isEmpty {
            // This is a refinement request
            ollamaService.refineSteps(currentSteps: lastSteps, userFeedback: message)
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completion in
                        self.isLoading = false
                        if case let .failure(error) = completion {
                            self.chatMessages.append(ChatMessage(type: .error("Error: \(error.localizedDescription)")))
                            self.scrollID = UUID()
                        }
                    },
                    receiveValue: { steps in
                        self.chatMessages.append(ChatMessage(type: .agentSteps(steps)))
                        self.isLoading = false
                        self.scrollID = UUID()
                    }
                )
                .store(in: &cancellables)
        } else {
            // This is an initial request
            ollamaService.generateSteps(from: message)
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completion in
                        self.isLoading = false
                        if case let .failure(error) = completion {
                            self.chatMessages.append(ChatMessage(type: .error("Error: \(error.localizedDescription)")))
                            self.scrollID = UUID()
                        }
                    },
                    receiveValue: { steps in
                        self.chatMessages.append(ChatMessage(type: .agentSteps(steps)))
                        self.isLoading = false
                        self.scrollID = UUID()
                    }
                )
                .store(in: &cancellables)
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        withAnimation(.easeOut(duration: 0.2)) {
            proxy.scrollTo(scrollID, anchor: .bottom)
        }
    }
    
    private func simulateExecution() {
        guard currentExecutingStep < executingSteps.count else { return }
        
        // Simulate the time it takes to execute a step
        let executionTime = Double.random(in: 2.0...4.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + executionTime) {
            // Move to next step
            self.currentExecutingStep += 1
            
            // Continue execution if there are more steps
            if self.currentExecutingStep < self.executingSteps.count {
                self.simulateExecution()
            }
        }
    }
    
    private func statusColor(for stepIndex: Int) -> Color {
        if stepIndex < currentExecutingStep {
            return Color.green  // Completed
        } else if stepIndex == currentExecutingStep {
            return Color.blue   // In progress
        } else {
            return Color.gray.opacity(0.5)  // Pending
        }
    }
}

struct OverlayContentView_Previews: PreviewProvider {
    static var previews: some View {
        OverlayContentView(
            closeOverlay: { print("Overlay closed.") },
            sendConfirmation: { steps in
                print("Steps confirmed for execution:")
                steps.forEach { print("- \($0)") }
            }
        )
        .previewLayout(.sizeThatFits)
        .background(Color.gray) // For better preview visibility
    }
}
