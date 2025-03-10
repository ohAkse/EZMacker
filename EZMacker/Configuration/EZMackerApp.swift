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
import Network
import CoreLocation
@main
struct EZMackerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var systemThemeService: SystemThemeService
    private let modelContainer: ModelContainer
    private let viewModelFactory: ViewModelFactory
    init() {
        let (container, modelContainer) = Self.configEnvironment()
        self.modelContainer = modelContainer
        self.viewModelFactory = ViewModelFactory(container: container)
         _systemThemeService = StateObject(wrappedValue: SystemThemeService())
    }
    private static func configEnvironment() -> (DependencyContainer, ModelContainer) {
        let modelContainer = configModelContainer()
        let container = configDependencyContainer(with: modelContainer)
        return (container, modelContainer)
    }
    private static func configModelContainer() -> ModelContainer {
        let schema = Schema([AppSettings.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // MARK: 현재는 SwiftData 마이그레이션 방법이 있는데 처리는 나중에 하기로하고 일단 스토리지지우고 리셋하는방식으로..
            // print(URL.applicationSupportDirectory.appendingPathComponent("default.store"))
            // try? FileManager.default.removeItem(at: URL.applicationSupportDirectory.appendingPathComponent("default.store"))
            Logger.fatalErrorMessage("Could not create ModelContainer: \(error)")
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    private static func configDependencyContainer(with modelContainer: ModelContainer) -> DependencyContainer {
        let container = DependencyContainer.shared
        container.setContext(modelContainer.mainContext)
        registerDependencies(in: container)
        
        return container
    }
    
    private static func registerDependencies(in container: DependencyContainer) {
        var dependencyList: [DependencyRegisterable] =
        [
            SmartGlobalDependency(),
            SmartBatteryDependency(),
            SmartWifiDependency(),
            SmartFileLocatorDependency(),
            SmartFileSearchDependency(),
            SmartNotificationAlarmDependency(),
            SmartImageTunerDependency()
        ]
        #if DEBUG
        dependencyList.append(SmartMockDependency())
        #endif
        dependencyList.forEach { $0.register(in: container) }
    }
    var body: some Scene {
        WindowGroup {
            MainContentView(factory: viewModelFactory)
                .frame(minWidth: 1100, minHeight: 730)
                .environmentObject(systemThemeService)
                .modelContainer(modelContainer)
        }
        .windowToolbarStyle(.unifiedCompact)
        .windowResizability(.contentSize)
    }
}
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate {
    private(set) weak var window: NSWindow?
    private(set) var originalFrame: NSRect?
    private var alertManager = AppAlertManager.shared
    private let systemConfigService = SystemPreferenceService()
    private var locationManager: CLLocationManager?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        UNUserNotificationCenter.current().delegate = self
        window = NSApp.windows.first
        window?.delegate = self
        requestNotificationAuthorization()
        requestLocationServices()
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let _ = self else {
                return nil
            }
            let modifierFlag = ModifierFlag(event.modifierFlags)
            let character = KeyboardCharacter(event.keyCode)
            KeyboardShortcutHandler.handleEvent(modifierFlag: modifierFlag, character: character)
            return event
        }
    }
    private func requestLocationServices() {
        if #available(macOS 15.0, *) {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    private func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
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
