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

// Service provider class to manage execution service and cancellables
class ExecutionServiceProvider: ObservableObject {
    let stepsExecutionService = StepsExecutionService()
    var cancellables = Set<AnyCancellable>()
    
    func connectToStepUpdates(updateStep: @escaping (StepUpdate) -> Void, fallbackToSimulation: @escaping () -> Void) {
        stepsExecutionService.connectToStepUpdates()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("WebSocket connection closed normally")
                case .failure(let error):
                    print("WebSocket error: \(error)")
                    // Fall back to simulated execution if websocket fails
                    fallbackToSimulation()
                }
            }, receiveValue: { stepUpdate in
                DispatchQueue.main.async {
                    updateStep(stepUpdate)
                }
            })
            .store(in: &cancellables)
    }
    
    func cleanupConnections() {
        stepsExecutionService.disconnectFromStepUpdates()
        cancellables.removeAll()
    }
}

struct OverlayContentView: View {
    // Callback to dismiss the overlay
    var closeOverlay: () -> Void
    // Callback to send the confirmed steps to the backend
    var sendConfirmation: (_ steps: [String]) -> Void
    
    // MARK: - State Properties
    @State private var userPrompt: String = ""
    @State private var chatMessages: [ChatMessage] = []
    @State private var isLoading: Bool = false
    @State private var viewState: OverlayViewState = .chat
    @State private var currentExecutingStep: Int = 0
    @State private var executingSteps: [String] = []
    @State private var scrollID = UUID()
    
    // Backend services
    @StateObject private var serviceProvider = ExecutionServiceProvider()
    
    // Track focus for the input field
    @FocusState private var isTextFieldFocused: Bool
    
    // Color palette based on Notion's light grey scheme
    private let backgroundColor = Color(hex: "F7F6F3")
    private let textColor = Color(hex: "37352F")
    private let secondaryTextColor = Color(hex: "6B6B6B")
    private let highlightColor = Color(hex: "2382E5")
    private let successColor = Color(hex: "0F9D58")
    private let dividerColor = Color(hex: "E8E8E8")
    private let inputBackgroundColor = Color.white
    
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
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header with minimal design
                HStack(spacing: 8) {
                    // App icon - replaced with a safe fallback approach
                    if let appIcon = NSImage(named: "logo") {
                        Image(nsImage: appIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18)
                            .cornerRadius(4)
                    } else {
                        // Fallback to a system icon if app icon isn't available
                        Image(systemName: "sparkles")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                    }
                    
                    Text(viewState == .chat ? "Intervene" : "Executing")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(textColor)
                    
                    Spacer()
                    
                    // Close button (X)
                    Button(action: closeOverlay) {
                        Image(systemName: "xmark")
                            .foregroundColor(secondaryTextColor)
                            .font(.system(size: 14))
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(backgroundColor)
                
                Divider()
                    .background(dividerColor)
                
                if viewState == .chat {
                    simpleChatView
                } else {
                    executingView
                }
            }
            .frame(width: 350, height: 450)
            .background(backgroundColor)
            .cornerRadius(12)
            .shadow(color: Color(hex: "DDDDDD"), radius: 12, x: 0, y: 2)
            .onDisappear {
                serviceProvider.cleanupConnections()
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
                        // Use enumerated ForEach to add dividers between messages.
                        ForEach(Array(chatMessages.enumerated()), id: \.element.id) { index, message in
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
                                                .foregroundColor(textColor)
                                                .multilineTextAlignment(.trailing)
                                                .lineLimit(nil)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .frame(maxWidth: 280, alignment: .trailing)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        
                                    case .agentSteps(let steps):
                                        // Agent message - left aligned
                                        VStack(alignment: .leading, spacing: 12) {
                                            ForEach(steps.indices, id: \.self) { index in
                                                HStack(alignment: .top, spacing: 8) {
                                                    Text("\(index + 1).")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(textColor)
                                                    
                                                    Text(steps[index])
                                                        .font(.system(size: 14))
                                                        .foregroundColor(textColor)
                                                        .multilineTextAlignment(.leading)
                                                        .lineLimit(nil)
                                                        .fixedSize(horizontal: false, vertical: true)
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                            .id(message.id)
                            
                            // Add a horizontal translucent gray divider between messages
                            if index < chatMessages.count - 1 {
                                Divider()
                                    .background(Color.gray.opacity(0.5))
                                    .padding(.horizontal, 16)
                            }
                        }
                        
                        // For automatic scrolling
                        Color.clear.frame(height: 1).id(scrollID)
                        
                        if isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(0.7)
                                Spacer()
                            }
                            .padding()
                        }
                    }
                }
                .onChange(of: scrollID) { _, _ in
                    scrollToBottom(proxy: scrollProxy)
                }
            }
            .background(backgroundColor)
            
            // "Confirm" button if we have agent steps
            if let steps = latestAgentSteps, !steps.isEmpty {
                VStack(spacing: 16) {
                    Divider()
                        .background(dividerColor)
                    
                    Button(action: {
                        executingSteps = steps
                        currentExecutingStep = 0
                        viewState = .executing
                        // Start the execution process
                        sendConfirmation(steps)
                    }) {
                        Text("Confirm")
                            .font(.system(size: 14, weight: .medium))
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(highlightColor)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                }
            }
            
            // Input area: Single-line TextField with custom border behavior.
            VStack(spacing: 0) {
                Divider()
                    .background(dividerColor)
                
                HStack(spacing: 12) {
                    // Improved text field with clean styling
                    ZStack(alignment: .leading) {
                        if userPrompt.isEmpty {
                            Text("What would you like me to do?")
                                .font(.system(size: 14))
                                .foregroundColor(secondaryTextColor.opacity(0.7))
                                .padding(.leading, 8)
                        }
                        
                        TextField("", text: $userPrompt)
                            .font(.system(size: 14))
                            .foregroundColor(textColor)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .disabled(isLoading)
                            .onSubmit {
                                sendMessage()
                            }
                    }
                    .frame(height: 36)
                    .background(inputBackgroundColor)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(dividerColor, lineWidth: 1)
                    )
                    
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(userPrompt.isEmpty || isLoading ? secondaryTextColor : highlightColor)
                    }
                    .disabled(userPrompt.isEmpty || isLoading)
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(backgroundColor)
            }
        }
    }
    
    // MARK: - Executing View
    private var executingView: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title and progress
            HStack {
                Text("Step \(currentExecutingStep + 1) of \(executingSteps.count)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(textColor)
                
                Spacer()
                
                // Loading indicator for current step
                if currentExecutingStep < executingSteps.count {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(0.7)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            // Steps list
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(executingSteps.indices, id: \.self) { index in
                        HStack(alignment: .center, spacing: 12) {
                            // Simple circle indicator
                            Circle()
                                .fill(index < currentExecutingStep ? successColor
                                      : (index == currentExecutingStep ? highlightColor
                                      : Color.gray.opacity(0.3)))
                                .frame(width: 18, height: 18)
                            
                            Text(executingSteps[index])
                                .font(.system(size: 14))
                                .foregroundColor(index < currentExecutingStep
                                                 ? textColor.opacity(0.7)
                                                 : (index == currentExecutingStep
                                                    ? textColor
                                                    : textColor.opacity(0.5)))
                                .strikethrough(index < currentExecutingStep, color: textColor.opacity(0.5))
                                .lineLimit(2)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                    }
                }
            }
            .background(backgroundColor)
            
            Spacer()
            
            // Return to chat button (when all steps are complete)
            if currentExecutingStep >= executingSteps.count {
                VStack(spacing: 8) {
                    Text("All steps completed")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(successColor)
                    
                    Button(action: {
                        serviceProvider.cleanupConnections()
                        viewState = .chat
                    }) {
                        Text("Return to Chat")
                            .font(.system(size: 14, weight: .medium))
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(successColor)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            } else {
                Text("Executing...")
                    .font(.system(size: 12))
                    .foregroundColor(secondaryTextColor)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
        }
        .onAppear {
            startRealExecution()
        }
    }
    
    // MARK: - Methods
    
    private func sendMessage() {
        guard !userPrompt.isEmpty && !isLoading else { return }
        
        // Add user message to chat
        chatMessages.append(ChatMessage(type: .userMessage(userPrompt)))
        
        // Save and clear the prompt
        let prompt = userPrompt
        userPrompt = ""
        isLoading = true
        
        // Update scroll position
        scrollID = UUID()
        
        // Simulate agent response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let steps = self.generateStepsBasedOn(prompt)
            self.chatMessages.append(ChatMessage(type: .agentSteps(steps)))
            self.isLoading = false
            self.scrollID = UUID()
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        withAnimation(.easeOut(duration: 0.2)) {
            proxy.scrollTo(scrollID, anchor: .bottom)
        }
    }
    
    private func generateStepsBasedOn(_ prompt: String) -> [String] {
        // This would be replaced with actual API call to your backend agent
        if prompt.lowercased().contains("email") {
            return [
                "Scan inbox for unread messages",
                "Draft replies based on your guidelines",
                "Update deal sheet with new data",
                "Log activity for record keeping",
                "Send notification when complete"
            ]
        } else if prompt.lowercased().contains("meeting") {
            return [
                "Check your calendar for availability",
                "Draft meeting agenda",
                "Send invites to participants",
                "Prepare meeting notes template",
                "Set up reminders"
            ]
        } else {
            return [
                "Analyze your request: \"\(prompt)\"",
                "Gather relevant information",
                "Process data according to guidelines",
                "Prepare results for review",
                "Finalize task and generate report"
            ]
        }
    }
    
    // MARK: - Real execution methods
    
    private func startRealExecution() {
        serviceProvider.connectToStepUpdates(
            updateStep: { stepUpdate in
                self.currentExecutingStep = stepUpdate.completedStepIndex + 1
            },
            fallbackToSimulation: {
                self.simulateExecution()
            }
        )
    }
    
    // Kept as a fallback if real execution fails
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

// MARK: - Color from Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview
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
        .background(Color.gray) // For better preview contrast
    }
}
