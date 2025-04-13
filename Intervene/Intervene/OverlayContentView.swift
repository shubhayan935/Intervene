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
    private let ollamaService = OllamaProcessService()
    
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
    @State private var showConnectionError: Bool = false
    
    // Notion-inspired color scheme
    private let primaryColor = Color(red: 0.13, green: 0.13, blue: 0.13)
    private let accentColor = Color(red: 0.0, green: 0.45, blue: 0.85)
    private let successColor = Color(red: 0.17, green: 0.67, blue: 0.45)
    private let errorColor = Color(red: 0.91, green: 0.3, blue: 0.24)
    private let surfaceColor = Color.white
    private let textColor = Color(red: 0.2, green: 0.2, blue: 0.2)
    private let subtleColor = Color(red: 0.5, green: 0.5, blue: 0.5)
    private let borderColor = Color(red: 0.9, green: 0.9, blue: 0.9)
    private let hoverColor = Color(red: 0.97, green: 0.97, blue: 0.97)
    
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
            // Main content container with Notion-like design
            VStack(spacing: 0) {
                // Header with title and controls
                notionHeader
                
                if viewState == .chat {
                    notionChatView
                } else {
                    notionExecutionView
                }
            }
            .background(surfaceColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(borderColor, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 4)
            .frame(width: 380, height: 500)
            
            // Connection error alert
            if showConnectionError {
                notionErrorAlert
            }
        }
        .onAppear {
            checkOllamaStatus()
        }
    }
    
    // MARK: - Notion-like Header View
    private var notionHeader: some View {
        HStack(spacing: 16) {
            // Title with minimal icon
            HStack(spacing: 10) {
                Image(systemName: "bolt")
                    .font(.system(size: 16))
                    .foregroundColor(accentColor)
                
                Text(viewState == .chat ? "Agent Assistant" : "Executing Steps")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(textColor)
            }
            
            Spacer()
            
            // Ollama status indicator
            HStack(spacing: 6) {
                Circle()
                    .fill(ollamaAvailable ? successColor : errorColor)
                    .frame(width: 6, height: 6)
                
                Text(ollamaAvailable ? "Connected" : "Offline")
                    .font(.system(size: 12))
                    .foregroundColor(subtleColor)
            }
            .onTapGesture {
                if !ollamaAvailable {
                    showConnectionError = true
                    // Auto-dismiss after 3 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        showConnectionError = false
                    }
                }
            }
            
            // Close button
            Button(action: closeOverlay) {
                Image(systemName: "xmark")
                    .font(.system(size: 12))
                    .foregroundColor(subtleColor)
                    .padding(4)
                    .background(Circle().fill(Color.clear))
                    .contentShape(Circle())
            }
            .buttonStyle(PlainButtonStyle())
            .padding(4)
            .background(Circle().fill(Color.clear))
            .contentShape(Circle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(surfaceColor)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(borderColor),
            alignment: .bottom
        )
    }
    
    // MARK: - Notion-like Chat View
    private var notionChatView: some View {
        VStack(spacing: 0) {
            // Chat messages with minimal styling
            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        if chatMessages.isEmpty {
                            // Empty state with minimal suggestion design
                            notionEmptyStateView
                        }
                        
                        ForEach(chatMessages) { message in
                            VStack(spacing: 0) {
                                // Message content
                                notionMessageView(for: message)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                
                                // Subtle divider
                                if message.id != chatMessages.last?.id {
                                    Divider()
                                        .background(borderColor)
                                        .padding(.horizontal, 16)
                                }
                            }
                            .id(message.id)
                        }
                        
                        // Loading indicator
                        if isLoading {
                            notionLoadingIndicator
                        }
                        
                        // For automatic scrolling
                        Color.clear.frame(height: 1).id(scrollID)
                    }
                    .padding(.vertical, 10)
                }
                .onChange(of: scrollID) { oldValue, newValue in
                    scrollToBottom(proxy: scrollProxy)
                }
            }
            
            // Show Intervene button if we have agent steps
            if let steps = latestAgentSteps, !steps.isEmpty {
                notionInterveneButton(steps: steps)
            }
            
            // Input area
            notionInputArea
        }
    }
    
    // Notion-like empty state view
    private var notionEmptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "text.bubble")
                .font(.system(size: 32))
                .foregroundColor(subtleColor.opacity(0.4))
            
            Text("What would you like help with?")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(textColor)
            
            VStack(alignment: .leading, spacing: 8) {
                notionSuggestionButton("Organize my emails and update spreadsheets")
                notionSuggestionButton("Schedule meetings and prepare notes")
                notionSuggestionButton("Research a topic and create a summary")
            }
            .frame(maxWidth: 300)
            
            Spacer()
        }
        .padding(.bottom, 40)
    }
    
    // Notion-style suggestion button
    private func notionSuggestionButton(_ text: String) -> some View {
        Button(action: {
            userPrompt = text
            sendMessage()
        }) {
            HStack {
                Text(text)
                    .font(.system(size: 14))
                    .foregroundColor(textColor)
                    .lineLimit(1)
                
                Spacer()
                
                Image(systemName: "arrow.right.circle")
                    .font(.system(size: 12))
                    .foregroundColor(accentColor)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(hoverColor)
            .cornerRadius(4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // Notion-style message view
    private func notionMessageView(for message: ChatMessage) -> some View {
        Group {
            switch message.type {
            case .userMessage(let text):
                // User message with icon
                HStack(alignment: .top, spacing: 10) {
                    // User icon
                    ZStack {
                        Circle()
                            .fill(accentColor.opacity(0.1))
                            .frame(width: 24, height: 24)
                        
                        Text("U")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(accentColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("You")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(subtleColor)
                        
                        Text(text)
                            .font(.system(size: 14))
                            .foregroundColor(textColor)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
            case .agentSteps(let steps):
                // Agent steps with checkbox styling
                HStack(alignment: .top, spacing: 10) {
                    // Agent icon
                    ZStack {
                        Circle()
                            .fill(primaryColor.opacity(0.05))
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 10))
                            .foregroundColor(accentColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Agent")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(subtleColor)
                        
                        ForEach(steps.indices, id: \.self) { index in
                            HStack(alignment: .top, spacing: 8) {
                                // Checkbox style
                                ZStack {
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(subtleColor.opacity(0.5), lineWidth: 1)
                                        .frame(width: 16, height: 16)
                                }
                                
                                Text(steps[index])
                                    .font(.system(size: 14))
                                    .foregroundColor(textColor)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
            case .error(let errorMessage):
                // Error message with Notion styling
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(errorColor)
                        .font(.system(size: 14))
                    
                    Text(errorMessage)
                        .font(.system(size: 14))
                        .foregroundColor(textColor)
                        .multilineTextAlignment(.leading)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(errorColor.opacity(0.05))
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(errorColor.opacity(0.2), lineWidth: 1)
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    // Loading indicator with Notion-like simplicity
    private var notionLoadingIndicator: some View {
        HStack(spacing: 6) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(accentColor.opacity(0.4))
                    .frame(width: 6, height: 6)
                    .scaleEffect(isLoading ? 1.0 : 0.5)
                    .opacity(isLoading ? 1.0 : 0.3)
                    .animation(
                        Animation.easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                        value: isLoading
                    )
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // Notion-style Intervene button
    private func notionInterveneButton(steps: [String]) -> some View {
        Button(action: {
            executingSteps = steps
            currentExecutingStep = 0
            viewState = .executing
            // Start the execution process
            sendConfirmation(steps)
        }) {
            HStack(spacing: 6) {
                Text("Intervene")
                    .font(.system(size: 14, weight: .medium))
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 12))
            }
            .foregroundColor(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(accentColor)
            .cornerRadius(4)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(surfaceColor)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(borderColor),
            alignment: .top
        )
    }
    
    // Notion-style input area
    private var notionInputArea: some View {
        VStack(spacing: 8) {
            // Connection warning
            if !ollamaAvailable {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: 12))
                        .foregroundColor(errorColor)
                    
                    Text("Ollama not connected")
                        .font(.system(size: 12))
                        .foregroundColor(errorColor)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            
            // Input field and button
            HStack(spacing: 12) {
                // Text field with Notion styling
                TextField("Enter your instructions...", text: $userPrompt)
                    .font(.system(size: 14))
                    .foregroundColor(textColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(hoverColor)
                    .cornerRadius(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(borderColor, lineWidth: 1)
                    )
                    .disabled(isLoading || !ollamaAvailable)
                    .onSubmit {
                        sendMessage()
                    }
                
                // Send button
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(userPrompt.isEmpty || isLoading || !ollamaAvailable
                                     ? subtleColor
                                     : accentColor)
                        )
                }
                .disabled(userPrompt.isEmpty || isLoading || !ollamaAvailable)
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            .padding(.top, 4)
            .background(surfaceColor)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(borderColor),
                alignment: .top
            )
        }
    }
    
    // MARK: - Notion-like Execution View
    private var notionExecutionView: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Progress info with Notion simplicity
            HStack {
                Text("Executing steps")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(textColor)
                
                Spacer()
                
                // Simple progress counter
                Text("\(currentExecutingStep)/\(executingSteps.count)")
                    .font(.system(size: 14))
                    .foregroundColor(subtleColor)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            // Clean progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Background
                    Rectangle()
                        .fill(borderColor)
                        .frame(height: 4)
                    
                    // Fill
                    Rectangle()
                        .fill(accentColor)
                        .frame(width: geo.size.width * CGFloat(max(CGFloat(currentExecutingStep) / CGFloat(executingSteps.count), 0.0)), height: 4)
                }
            }
            .frame(height: 4)
            
            // Steps list with clean styling
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(executingSteps.indices, id: \.self) { index in
                        notionStepView(for: index)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            
            Spacer()
            
            // Return to chat button or current step info
            if currentExecutingStep >= executingSteps.count {
                // All steps complete
                notionCompletionView
            } else {
                // Still executing
                notionStepProgressView
            }
        }
        .onAppear {
            simulateExecution()
        }
    }
    
    // Notion-style step view in execution mode
    private func notionStepView(for index: Int) -> some View {
        HStack(alignment: .top, spacing: 12) {
            // Status indicator
            ZStack {
                RoundedRectangle(cornerRadius: 3)
                    .stroke(index < currentExecutingStep ? successColor : (index == currentExecutingStep ? accentColor : subtleColor.opacity(0.5)), lineWidth: 1)
                    .frame(width: 16, height: 16)
                
                if index < currentExecutingStep {
                    // Completed
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(successColor)
                } else if index == currentExecutingStep {
                    // In progress
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: accentColor))
                        .scaleEffect(0.5)
                }
            }
            
            // Step text
            Text(executingSteps[index])
                .font(.system(size: 14))
                .foregroundColor(index <= currentExecutingStep ? textColor : subtleColor)
                .strikethrough(index < currentExecutingStep, color: subtleColor)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(index == currentExecutingStep ? hoverColor : Color.clear)
        .cornerRadius(4)
        .animation(.easeInOut(duration: 0.2), value: currentExecutingStep)
    }
    
    // Current step progress view
    private var notionStepProgressView: some View {
        HStack(spacing: 8) {
            if currentExecutingStep < executingSteps.count {
                Text("Running: \(executingSteps[currentExecutingStep])")
                    .font(.system(size: 13))
                    .foregroundColor(subtleColor)
                    .lineLimit(1)
                
                Spacer()
                
                // Simple spinner
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: accentColor))
                    .scaleEffect(0.6)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(surfaceColor)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(borderColor),
            alignment: .top
        )
    }
    
    // Completion view when all steps are done
    private var notionCompletionView: some View {
        VStack(spacing: 12) {
            // Success indicator
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 16))
                    .foregroundColor(successColor)
                
                Text("All steps completed")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(textColor)
            }
            
            // Return to chat button
            Button(action: {
                viewState = .chat
            }) {
                Text("Return to Chat")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(accentColor)
                    .cornerRadius(4)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(surfaceColor)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(borderColor),
            alignment: .top
        )
    }
    
    // Error alert with Notion styling
    private var notionErrorAlert: some View {
        VStack(spacing: 12) {
            // Title
            Text("Connection Error")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(textColor)
            
            // Message
            Text("Make sure Ollama is running on your system")
                .font(.system(size: 13))
                .foregroundColor(subtleColor)
                .multilineTextAlignment(.center)
            
            // Retry button
            Button(action: {
                checkOllamaStatus()
                showConnectionError = false
            }) {
                Text("Retry")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(accentColor)
                    .cornerRadius(4)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(20)
        .background(surfaceColor)
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(borderColor, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
        .transition(.opacity)
        .zIndex(100)
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
    }
}
