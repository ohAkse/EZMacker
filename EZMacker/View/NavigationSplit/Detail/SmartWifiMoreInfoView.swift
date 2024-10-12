//
//  SmartWifiMoreInfoView.swift
//  EZMacker
//
//  Created by 박유경 on 10/12/24.
//

import SwiftUI
import EZMackerServiceLib

struct WifiMoreInfoView: View {
    @ObservedObject var smartWifiViewModel: SmartWifiViewModel<AppSmartWifiService>
    
    var body: some View {
        List {
            Section(header: Text("연결 정보")) {
                Text("SSID: \(smartWifiViewModel.wificonnectData.connectedSSid)")
                Text("신호 강도: \(smartWifiViewModel.wificonnectData.strength)")
            }
            
            Section(header: Text("라디오 채널 정보")) {
                Text("대역폭: \(smartWifiViewModel.radioChannelData.channelBandwidth)")
                Text("주파수: \(smartWifiViewModel.radioChannelData.channelFrequency)")
                Text("채널: \(smartWifiViewModel.radioChannelData.channel)")
                Text("대역: \(smartWifiViewModel.radioChannelData.band)")
                Text("MAC 주소: \(smartWifiViewModel.radioChannelData.macAddress)")
                Text("지역: \(smartWifiViewModel.radioChannelData.locale)")
            }
        }
        .ezBackgroundColorStyle()
        .navigationTitle(CategoryType.smartWifi.moreInfoTitle)
        .padding(30)
    }
}
