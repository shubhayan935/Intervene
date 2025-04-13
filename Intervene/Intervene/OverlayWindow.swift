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
        
        // Add visual effects view for background blur
        setupVisualEffectsBackground()
    }
    
    // Add a blurred background effect
    private func setupVisualEffectsBackground() {
        guard let contentView = contentView else { return }
        
        // Create visual effect view with vibrancy
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = .hudWindow
        visualEffectView.state = .active
        visualEffectView.blendingMode = .behindWindow
        
        // Configure the visual appearance
        visualEffectView.wantsLayer = true
        visualEffectView.layer?.cornerRadius = 12
        visualEffectView.layer?.masksToBounds = true
        
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
        
        // Animate to full opacity
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.2
            self.animator().alphaValue = 1.0
        })
    }
    
    // Add subtle animation when window disappears
    override func orderOut(_ sender: Any?) {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.2
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
