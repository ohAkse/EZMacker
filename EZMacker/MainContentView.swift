//
//  MainContentView.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import SwiftUI
struct MainContentView: View {
    @State private var selectionValue = CategoryType.smartBattery
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
        .toolbar(id: "Toolbar") {
            ColorSchemeToolbarView()
        }
    }
}

#Preview {
    MainContentView()
}
