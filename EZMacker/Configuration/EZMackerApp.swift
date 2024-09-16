//
//  EZMackerApp.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import Cocoa
import SwiftUI
import UserNotifications
import EZMackerUtilLib
import SwiftData

@main
struct EZMackerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var colorSchemeViewModel = ColorSchemeViewModel()

    var modelContainer: ModelContainer = {
          let schema = Schema([AppSettings.self])
          let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
          do {
              return try ModelContainer(for: schema, configurations: [modelConfiguration]) 
          } catch {
              fatalError("Could not create ModelContainer: \(error)")
          }
      }()
    var body: some Scene {
        WindowGroup {
            MainContentView()
                .frame(minWidth: 1100, minHeight: 730)
                .environmentObject(colorSchemeViewModel)
                .modelContainer(modelContainer)
        }
        .windowToolbarStyle(.unifiedCompact)
        .windowResizability(.contentSize)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject, NSWindowDelegate, UNUserNotificationCenterDelegate {
    private(set) weak var window: NSWindow?
    private(set) var originalFrame: NSRect?
    var alertManager = AppAlertManager.shared
    let systemConfigService = SystemPreferenceService()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        UNUserNotificationCenter.current().delegate = self
        window = NSApp.windows.first
        window?.delegate = self
        requestNotificationAuthorization()
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self = self else {
                return nil
            }
            let modifierFlag = ModifierFlag(event.modifierFlags)
            let character = KeyboardCharacter(event.keyCode)
            KeyboardShortcutHandler.handleEvent(modifierFlag: modifierFlag, character: character)
            return event
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if !granted {
                DispatchQueue.main.async {
                    AppAlertManager.shared.showNotificationPermissionDeniedAlert(
                        systemPath: SystemPreference.noti.pathString,
                        title: "알림 권한 거부됨",
                        message: "알림 권한이 거부되었습니다. 알림을 받으려면 시스템 설정에서 알림 권한을 허용해주세요.",
                        primaryButtonTitle: "설정으로 이동",
                        secondaryButtonTitle: "닫기"
                    )
                }
            }
        }
    }
}
