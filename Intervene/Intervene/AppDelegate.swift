//
//  AppDelegate.swift
//  Intervene
//
//  Created by Shubhayan Srivastava on 4/12/25.
//

import Foundation
import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var overlayWindow: OverlayWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create a status bar item with a square length for an icon
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem.button {
            // Set an icon for the status bar
            if let statusIcon = NSImage(named: "AppIcon") {
                // Configure the icon for menu bar use
                statusIcon.size = NSSize(width: 18, height: 18)
                statusIcon.isTemplate = true // This makes it adapt to dark/light mode
                button.image = statusIcon
            } else {
                // Fallback to the app icon if the dedicated status icon isn't found
                if let appIcon = NSImage(named: "logo") {
                    appIcon.size = NSSize(width: 18, height: 18)
                    button.image = appIcon
                }
            }
            
            // Add a click handler
            button.action = #selector(toggleOverlay)
            button.target = self
            
            // Make the status bar item look nicer
            button.appearsDisabled = false
        }
        
        // Set the application name for menu bar and dock
        // Note: The app icon for the dock is set through Info.plist and Assets.xcassets
        NSApp.setActivationPolicy(.regular) // Ensures it appears in the dock
    }
    
    @objc func toggleOverlay() {
        if overlayWindow == nil {
            createOverlayWindow()
        }
        guard let window = overlayWindow else { return }
        
        if window.isVisible {
            window.orderOut(nil)
        } else {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    private func createOverlayWindow() {
        // Dimensions for the overlay
        let overlayWidth: CGFloat = 350
        let overlayHeight: CGFloat = 450

        // Position near top-right of main screen
        guard let screen = NSScreen.main else { return }
        let screenRect = screen.frame
        let marginRight: CGFloat = 20
        let marginTop: CGFloat = 40
        
        // Calculate the top-right corner
        let xPos = screenRect.maxX - overlayWidth - marginRight
        let yPos = screenRect.maxY - overlayHeight - marginTop
        
        // Create our custom OverlayWindow
        let window = OverlayWindow(
            contentRect: NSRect(x: xPos, y: yPos, width: overlayWidth, height: overlayHeight),
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        // Create and embed our SwiftUI overlay
        let overlayView = OverlayContentView(
            closeOverlay: { [weak self] in
                self?.toggleOverlay()
            },
            sendConfirmation: { steps in
                self.sendStepsToBackend(steps)
            }
        )
        
        // Wrap in a hosting view
        let hostingView = NSHostingView(rootView: overlayView)
        hostingView.frame = NSRect(x: 0, y: 0, width: overlayWidth, height: overlayHeight)
        hostingView.autoresizingMask = [.width, .height]
        
        window.contentView = hostingView
        overlayWindow = window
    }
    
    // MARK: - Backend communication
    private func sendStepsToBackend(_ steps: [String]) {
        // In a real app, you would send these steps to your backend:
        // 1. Make an API call to your agent system
        // 2. Pass the confirmed steps for execution
        // 3. Handle success/failure responses
        
        print("Sending steps to backend:")
        steps.forEach { step in
            print("- \(step)")
        }
        
        // In the real implementation, you would connect to your Ollama service here
        // Example:
        // let ollamaService = OllamaService()
        // ollamaService.executeSteps(steps)
        //   .sink(receiveCompletion: { completion in
        //     // Handle completion
        //   }, receiveValue: { result in
        //     // Handle result
        //   })
        //   .store(in: &cancellables)
        
        // Keep the window open while executing in the real implementation
        // The execution status is now shown in the UI
    }
}
