//
//  OverlayWindow.swift
//  Intervene
//
//  Created by Shubhayan Srivastava on 4/12/25.
//

import Foundation
import Cocoa
import SwiftUI

class OverlayWindow: NSWindow {
    // Allow this window to become key window to receive keyboard events
    override var canBecomeKey: Bool {
        return true
    }

    // Allow this window to become main window
    override var canBecomeMain: Bool {
        return true
    }
    
    // Custom initializer for creating a polished overlay window
    override init(contentRect: NSRect, styleMask: NSWindow.StyleMask, backing: NSWindow.BackingStoreType, defer flag: Bool) {
        // Call parent initializer
        super.init(contentRect: contentRect,
                  styleMask: [.borderless, .fullSizeContentView],
                  backing: backing,
                  defer: flag)
        
        // Set window properties
        self.isOpaque = false
        self.hasShadow = true
        self.backgroundColor = NSColor.clear
        
        // Make sure it appears above other windows
        self.level = .floating
        
        // Enable dragging from any point in the window
        self.isMovableByWindowBackground = true
        
        // Make it appear and disappear with a fade animation
        self.animationBehavior = .utilityWindow
        
        // Simplified appearance with lighter visual effect
        setupMinimalisticBackground()
    }
    
    // Add a minimalistic background effect
    private func setupMinimalisticBackground() {
        guard let contentView = contentView else { return }
        
        // Create visual effect view with dark appearance
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = .dark // Dark material for a sleek look
        visualEffectView.state = .active
        visualEffectView.blendingMode = .behindWindow
        
        // Configure the visual appearance to be more modern
        visualEffectView.wantsLayer = true
        visualEffectView.layer?.cornerRadius = 12 // Rounded corners
        visualEffectView.layer?.masksToBounds = true
        
        // Add subtle border
        visualEffectView.layer?.borderWidth = 0.5
        visualEffectView.layer?.borderColor = NSColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0).cgColor
        
        // Add subtle shadow
        contentView.wantsLayer = true
        contentView.layer?.shadowColor = NSColor.black.withAlphaComponent(0.3).cgColor
        contentView.layer?.shadowOffset = NSSize(width: 0, height: 3)
        contentView.layer?.shadowRadius = 12
        contentView.layer?.shadowOpacity = 1.0
        
        // Insert the visual effects view behind all other content
        visualEffectView.frame = contentView.bounds
        visualEffectView.autoresizingMask = [.width, .height]
        contentView.addSubview(visualEffectView, positioned: .below, relativeTo: nil)
    }
    
    // Add subtle animation when window appears
    override func makeKeyAndOrderFront(_ sender: Any?) {
        // Start with zero opacity
        self.alphaValue = 0.0
        
        super.makeKeyAndOrderFront(sender)
        
        // Animate to full opacity with slight scale effect
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.15
            self.animator().alphaValue = 1.0
        })
    }
    
    // Add subtle animation when window disappears
    override func orderOut(_ sender: Any?) {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.15
            self.animator().alphaValue = 0.0
        }, completionHandler: {
            super.orderOut(sender)
        })
    }
    
    // Close window when escape key is pressed
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 { // Escape key
            self.orderOut(nil)
        } else {
            super.keyDown(with: event)
        }
    }
}
