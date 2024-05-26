//
//  EZMackerApp.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

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
        }
        .environmentObject(colorSchemeViewModel)
        .windowToolbarStyle(.unifiedCompact)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var alertManager = AppAlertManager.shared
    let systemConfigService = SystemPreferenceService()
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        window = NSApp.windows.first
        
        requestNotificationAuthorization()
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            let modifierFlag = ModifierFlag(event.modifierFlags)
            let character = KeyboardCharacter(event.keyCode)
            KeyboardShortcutHandler.handleEvent(modifierFlag: modifierFlag, character: character)
            return event
        }
    }
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
            } else {
                DispatchQueue.main.async {
                    AppAlertManager.shared.showNotificationPermissionDeniedAlert(systemPath: SystemPreference.noti.pathString)
                }
            }
        }
    }
}
