//
//  MainContentView.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import SwiftUI
struct MainContentView: View {
    @State private var selectionValue = CategoryType.smartBattery
    @AppStorage(AppStorageKey.colorSchme.name) var colorScheme = AppStorageKey.colorSchme.byDefault
    var body: some View {
        NavigationSplitView {
            CategoryView(selectionValue: $selectionValue)
                .frame(width: 200)
        } detail: {
            switch selectionValue {
            case .smartBattery:
                SmartBatteryView(smartBatteryViewModel: SmartBatteryViewModel(appSmartBatteryService: AppSmartBatteryService()))
            case .smartFile:
                SmartFileView(smartFileViewModel: SmartFileViewModel(appSmartFileService: AppSmartFileService()))
            }
        }
        .toolbar(id: ToolbarKey.MainToolbar.name) {
            ColorSchemeToolbarView()
        }
        .preferredColorScheme(colorScheme == ColorSchemeMode.Dark.title ? .dark : .light)
    }
}

#Preview {
    MainContentView()
}
