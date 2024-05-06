//
//  SmartBatteryView.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import SwiftUI
struct SmartBatteryView: View {
    @ObservedObject var smartBatteryViewModel: SmartBatteryViewModel
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .customImage(imageScale: .large)
            Text(CategoryType.smartBattery.title)
                .customText(fontSize: FontSizeType.small.size, isBold: false)
        }
        .navigationTitle(CategoryType.smartBattery.title)
        .padding()
    }
}
