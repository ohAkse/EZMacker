//
//  KeyboardShortCutHandler.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import SwiftUI

enum KeyboardShortcutHandler {
    static func handleEvent(modifierFlag: ModifierFlag, character: KeyboardCharacter) {
        switch (modifierFlag, character) {
        case (.command, .comma):
            miniaturizeWindow()
        case (.command, .period):
            zoomWindow()
        case (.command, .slash):
            makeFrontWindow()
        case (.command, .openSquareBracket):
            moveWindowToTopLeft()
        case (.command, .closeSquareBracket):
            moveWindowToTopRight()
        case (.command, .semicolon):
            moveWindowToBottomLeft()
        case (.command, .apostrophe):
            moveWindowToBottomRight()
        case (.command, .leftArrow):
            moveWindowToMonitorEdge(direction: .leftArrow)
        case (.command, .rightArrow):
            moveWindowToMonitorEdge(direction: .rightArrow)
        case (.command, .topArrow):
            moveWindowSlightly(direction: .topArrow)
        case (.command, .bottomArrow):
            moveWindowSlightly(direction: .bottomArrow)
        case (.command, .one):
            moveWindowToMonitorCenter(screenNumber: 1)
        case (.command, .two):
            moveWindowToMonitorCenter(screenNumber: 2)
        default:
            break
        }
    }
    static func miniaturizeWindow() {
        if let window = NSApp.windows.first {
            window.miniaturize(nil)
        }
    }
    static func zoomWindow() {
        if let window = NSApp.windows.first {
            window.zoom(nil)
        }
    }
    static func makeFrontWindow() {
        NSApp.setActivationPolicy(.regular)
        if let window = NSApp.windows.first {
            window.makeKeyAndOrderFront(nil)
        }
    }
    static func moveWindowToTopLeft() {
        if let window = NSApplication.shared.windows.first {
            let screenFrame = NSScreen.main?.frame ?? .zero
            
            let newOrigin = NSPoint(x: screenFrame.minX, y: screenFrame.maxY)
            window.setFrameOrigin(newOrigin)
        }
    }
    static func moveWindowToTopRight() {
        if let window = NSApplication.shared.windows.first {
            let screenFrame = NSScreen.main?.frame ?? .zero
            
            let windowFrame = window.frame
            
            var newOrigin = NSPoint(x: screenFrame.maxX, y: screenFrame.maxY)
            
            if newOrigin.x + windowFrame.width > screenFrame.maxX {
                newOrigin.x = screenFrame.maxX - windowFrame.width
            }
            if newOrigin.y + windowFrame.height > screenFrame.maxY {
                newOrigin.y = screenFrame.maxY - windowFrame.height
            }
            window.setFrameOrigin(newOrigin)
        }
    }
    static func moveWindowToBottomLeft() {
        if let window = NSApplication.shared.windows.first {
            let screenFrame = NSScreen.main?.frame ?? .zero
            
            let newOrigin = NSPoint(x: screenFrame.minX, y: screenFrame.minY)
            window.setFrameOrigin(newOrigin)
        }
    }
    static func moveWindowToBottomRight() {
        if let window = NSApplication.shared.windows.first {
            let screenFrame = NSScreen.main?.frame ?? .zero
            let windowFrame = window.frame
            
            var newOrigin = NSPoint(x: screenFrame.maxX, y: screenFrame.minY)
            
            if newOrigin.x + windowFrame.width > screenFrame.maxX {
                newOrigin.x = screenFrame.maxX - windowFrame.width
            }
            if newOrigin.y + windowFrame.height > screenFrame.maxY {
                newOrigin.y = screenFrame.maxY - windowFrame.height
            }
            window.setFrameOrigin(newOrigin)
        }
    }
    static func moveWindowToMonitorEdge(direction: KeyboardCharacter) {
        guard let window = NSApp.keyWindow else { return }
        
        var newOrigin = window.frame.origin
        
        switch direction {
        case .leftArrow:
            let offsetX: CGFloat = -20
            newOrigin.x += offsetX
        case .rightArrow:
            let offsetX: CGFloat = 20
            newOrigin.x += offsetX
        default:
            break
        }
        window.setFrameOrigin(newOrigin)
    }
    static func moveWindowSlightly(direction: KeyboardCharacter) {
        guard let window = NSApp.keyWindow else { return }
        
        var newOrigin = window.frame.origin
        let offset: CGFloat = 20
        
        switch direction {
        case .topArrow:
            newOrigin.y += offset
        case .bottomArrow:
            newOrigin.y -= offset
        default:
            break
        }
        window.setFrameOrigin(newOrigin)
    }
    static func moveWindowToMonitorCenter(screenNumber: Int) {
        let screens = NSScreen.screens
        
        if screenNumber <= screens.count {
            let targetScreen = screens[screenNumber - 1]
            let screenFrame = targetScreen.frame
            guard let window = NSApp.keyWindow else { return }
            let windowFrame = window.frame
            var newOrigin = CGPoint.zero
            
            newOrigin.x = screenFrame.origin.x + (screenFrame.size.width - windowFrame.size.width) / 2
            newOrigin.y = screenFrame.origin.y + (screenFrame.size.height - windowFrame.size.height) / 2
            
            window.setFrameOrigin(newOrigin)
        }
    }
}
