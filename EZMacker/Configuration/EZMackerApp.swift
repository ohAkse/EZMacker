//
//  EZMackerApp.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import Cocoa
import SwiftUI
import UserNotifications

@main
struct EZMackerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var colorSchemeViewModel = ColorSchemeViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainContentView()
                .frame(minWidth: 1100, minHeight: 730)
                .environmentObject(colorSchemeViewModel)
        }
        .windowToolbarStyle(.unifiedCompact)
        .windowResizability(.contentSize)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject, NSWindowDelegate, UNUserNotificationCenterDelegate {
    var window: NSWindow!
    private var originalFrame: NSRect?
    var alertManager = AppAlertManager.shared
    let systemConfigService = SystemPreferenceService()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        let center = UNUserNotificationCenter.current()
            center.delegate = self
        
        window = NSApp.windows.first
        window.delegate = self
        requestNotificationAuthorization()
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            let modifierFlag = ModifierFlag(event.modifierFlags)
            let character = KeyboardCharacter(event.keyCode)
            KeyboardShortcutHandler.handleEvent(modifierFlag: modifierFlag, character: character)
            return event
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner, .sound]
    }
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if !granted {
                DispatchQueue.main.async {
                    AppAlertManager.shared.showNotificationPermissionDeniedAlert(systemPath: SystemPreference.noti.pathString)
                }
            }
        }
    }
}
