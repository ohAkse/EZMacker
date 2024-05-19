//
//  SmartWifiView.swift
//  EZMacker
//
//  Created by 박유경 on 5/19/24.
//

import SwiftUI
struct SmartWifiView: View {
    @ObservedObject var smartWifiViewModel: SmartWifiViewModel

    var body: some View {
        VStack {
            Text(CategoryType.smartWifi.title)
                .customNormalTextFont(fontSize: FontSizeType.small.size, isBold: false)
        }
        .navigationTitle(CategoryType.notificationAlarm.title)
        .padding()
    }
}
