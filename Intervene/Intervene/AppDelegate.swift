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
        // Create a status bar item with a square length for an icon, or variable for text
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem.button {
            // You can set an image or text
//            button.image = NSImage(systemName: "wand.and.stars")
            button.title = "IV"
            button.action = #selector(toggleOverlay)
            button.target = self
        }
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
        let overlayHeight: CGFloat = 450  // Increased height for chat UI

        // Position near top-right of main screen
        guard let screen = NSScreen.main else { return }
        let screenRect = screen.frame
        let marginRight: CGFloat = 20
        let marginTop: CGFloat = 40
        
        // Calculate the top-right corner
        let xPos = screenRect.maxX - overlayWidth - marginRight
        let yPos = screenRect.maxY - overlayHeight - marginTop
        
        // Create our custom OverlayWindow instead of a generic NSWindow
        let window = OverlayWindow(
            contentRect: NSRect(x: xPos, y: yPos, width: overlayWidth, height: overlayHeight),
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        // Embed our SwiftUI overlay
        let overlayView = OverlayContentView(
            closeOverlay: { [weak self] in
                self?.toggleOverlay()
            },
            sendConfirmation: { steps in
                self.sendStepsToBackend(steps)
            }
        )
        
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
        
        // Close the overlay after sending (you might want to wait for confirmation in a real app)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.toggleOverlay()
        }
    }
}
