//
//  AppSmartWifiService.swift
//  EZMacker
//
//  Created by 박유경 on 9/1/24.
//

import SwiftUI
import CoreWLAN
import EZMackerServiceLib

struct MainContentView: View {
    @EnvironmentObject private var appThemeManager: AppThemeManager
    @State private var selectionValue: CategoryType = {
        if AppEnvironment.shared.macBookType == .macMini {
            return CategoryType.smartWifi
        } else {
            return CategoryType.smartBattery
        }
    }()
    private let factory: ViewModelFactory
    
    init(factory: ViewModelFactory) {
        self.factory = factory
    }
    
    var body: some View {
        NavigationSplitView {
            CategoryView(selectionValue: $selectionValue)
                .frame(minWidth: 200)
                .contentShape(Rectangle())
        } detail: {
            switch selectionValue {
            case .smartBattery:
                SmartBatteryView<AppSmartBatteryService>(factory: factory)
            case .smartWifi:
                SmartWifiView<AppSmartWifiService>(factory: factory)
            case .smartFileLocator:
                SmartFileLocatorView(factory: factory)
            case .smartNotificationAlarm:
                SmartNotificationAlarmView(factory: factory)
            case .smartFileSearch:
                SmartFileSearchView(factory: factory)
            }
        }
        .toolbar(id: ToolbarKeyType.MainToolbar.name) {
            ToolbarItem(id: ToolbarKeyType.ColorSchemePicker.name, placement: .primaryAction) {
                HStack(spacing: 0) {
                    AppToolbarView(buttonTitle: ColorSchemeModeType.Light.title, buttonTag: ColorSchemeModeType.Light.tag)
                    AppToolbarView(buttonTitle: ColorSchemeModeType.Dark.title, buttonTag: ColorSchemeModeType.Dark.tag)
                }
                .padding(3)
                .overlay {
                    Capsule()
                        .stroke(.blue, lineWidth: 1)
                }
                .opacity(appThemeManager.isShowChooseColorScheme ? 1 : 0)
                .animation(.linear(duration: 0.2), value: appThemeManager.rotateDegree)
            }
            
            ToolbarItem(id: ToolbarKeyType.ColorSchemeButton.name, placement: .primaryAction) {
                Button {
                    appThemeManager.toggleColorScheme()
                } label: {
                    Image(systemName: ToolbarImage.colorSchemeButton.systemName)
                        .rotationEffect(.degrees(appThemeManager.rotateDegree))
                        .animation(.linear(duration: 0.2), value: appThemeManager.rotateDegree)
                }
            }
        }
        .preferredColorScheme(appThemeManager.colorScheme == ColorSchemeModeType.Dark.title ? .dark : .light)
    }
}
