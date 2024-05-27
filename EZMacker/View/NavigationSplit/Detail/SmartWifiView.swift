//
//  SmartWifiView.swift
//  EZMacker
//
//  Created by 박유경 on 5/19/24.
//

import SwiftUI

struct SmartWifiView<ProvidableType>: View where ProvidableType: AppSmartWifiServiceProvidable {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    @ObservedObject var smartWifiViewModel: SmartWifiViewModel<ProvidableType>
    init(smartWifiViewModel: SmartWifiViewModel<ProvidableType>) {
        self.smartWifiViewModel = smartWifiViewModel
    }
    var body: some View {
        VStack {
            Text(CategoryType.smartWifi.title)
                .customNormalTextFont(fontSize: FontSizeType.small.size, isBold: false)
        }
        .onAppear {
            smartWifiViewModel.requestWifiInfo()
            smartWifiViewModel.requestCoreWLanWifiInfo()
        }
        .navigationTitle(CategoryType.smartWifi.title)
        .padding()
    }
}
