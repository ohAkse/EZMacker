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
    @EnvironmentObject private var colorSchemeViewModel: ColorSchemeViewModel
    @Environment(\.modelContext) private var context
    @State private var selectionValue: CategoryType = {
        if AppEnvironment.shared.macBookType == .macMini {
            return CategoryType.smartWifi
        } else {
            return CategoryType.smartBattery
        }
    }()
    
    let factory: ViewModelFactory
    var body: some View {
        NavigationSplitView {
            CategoryView(selectionValue: $selectionValue)
                .frame(minWidth: 200)
                .contentShape(Rectangle())
        } detail: {
            GeometryReader { _ in
                switch selectionValue {
                case .smartBattery:
                    SmartBatteryView<AppSmartBatteryService>(factory: factory)
                        .environmentObject(colorSchemeViewModel)
                case .smartWifi:
                    SmartWifiView<AppSmartWifiService>(factory: factory)
                        .environmentObject(colorSchemeViewModel)
                case .smartFileLocator:
                    SmartFileLocatorView(factory: factory)
                        .environmentObject(colorSchemeViewModel)
                case .smartNotificationAlarm:
                    SmartNotificationAlarmView(factory: factory)
                        .environmentObject(colorSchemeViewModel)
                case .smartFileSearch:
                    SmartFileSearchView(factory: factory)
                        .environmentObject(colorSchemeViewModel)
                }
            }
        }
        .toolbar(id: ToolbarKeyType.MainToolbar.name) {
            ToolbarItem(id: ToolbarKeyType.ColorSchemePicker.name, placement: .primaryAction) {
                HStack(spacing: 0) {
                    ColorSchemeToolbarView(buttonTitle: ColorSchemeModeType.Light.title, buttonTag: ColorSchemeModeType.Light.tag)
                    ColorSchemeToolbarView(buttonTitle: ColorSchemeModeType.Dark.title, buttonTag: ColorSchemeModeType.Dark.tag)
                }
                .padding(3)
                .overlay {
                    Capsule()
                        .stroke(.blue, lineWidth: 1)
                }
                .opacity(colorSchemeViewModel.isShowChooseColorScheme ? 1 : 0)
                .animation(.linear(duration: 0.2), value: colorSchemeViewModel.rotateDegree)
            }
            
            ToolbarItem(id: ToolbarKeyType.ColorSchemeButton.name, placement: .primaryAction) {
                Button {
                    colorSchemeViewModel.toggleColorScheme()
                } label: {
                    Image(systemName: ToolbarImage.colorSchemeButton.systemName)
                        .rotationEffect(.degrees(colorSchemeViewModel.rotateDegree))
                        .animation(.linear(duration: 0.2), value: colorSchemeViewModel.rotateDegree)
                }
            }
        }
        .preferredColorScheme(colorSchemeViewModel.colorScheme == ColorSchemeModeType.Dark.title ? .dark : .light)
    }
}
