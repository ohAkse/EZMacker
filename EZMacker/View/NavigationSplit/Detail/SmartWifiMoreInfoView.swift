//
//  SmartWifiMoreInfoView.swift
//  EZMacker
//
//  Created by 박유경 on 10/12/24.
//

import SwiftUI
import EZMackerServiceLib
import EZMackerUtilLib

struct SmartWifiMoreInfoView: View {
    @StateObject var smartWifiMoreInfoViewModel: SmartWifiMoreInfoViewModel
    
    var body: some View {
        List {
            Section(header: Text("연결 정보")) {
                Text("SSID: \(smartWifiMoreInfoViewModel.wificonnectData.connectedSSid)")
                Text("신호 강도: \(smartWifiMoreInfoViewModel.wificonnectData.strength)dBM")
                Text("전송 속도: \(smartWifiMoreInfoViewModel.wificonnectData.transmitRate)")
                Text("비콘 간격: \(smartWifiMoreInfoViewModel.beaconInterval)")
            }
            
            // 라디오 채널 정보
            Section(header: Text("라디오 채널 정보")) {
                Text("대역폭: \(smartWifiMoreInfoViewModel.radioChannelData.channelBandwidth)MHz")
                Text("주파수: \(smartWifiMoreInfoViewModel.radioChannelData.channelFrequency)MHz")
                Text("채널: \(smartWifiMoreInfoViewModel.radioChannelData.channel)")
                Text("대역: \(smartWifiMoreInfoViewModel.radioChannelData.band)GHz")
                Text("MAC 주소: \(smartWifiMoreInfoViewModel.radioChannelData.macAddress)")
                Text("지역: \(smartWifiMoreInfoViewModel.radioChannelData.locale)")
            }
            // 인터페이스 정보(추가)
            Section(header: Text("인터페이스 정보")) {
                Text("인터페이스 이름: \(smartWifiMoreInfoViewModel.interfaceName)")
                Text("활성 PHY 모드: \(smartWifiMoreInfoViewModel.activePHYMode)")
                Text("전원 상태: \(smartWifiMoreInfoViewModel.powerOn ? "On" : "Off")")
                Text("지원되는 WLAN 채널: \(smartWifiMoreInfoViewModel.supportedWLANChannels.joined(separator: ", "))")
                Text("BSSID: \(smartWifiMoreInfoViewModel.bssid)")
                Text("잡음 측정: \(smartWifiMoreInfoViewModel.noiseMeasurement)dBm")
                Text("보안 모드: \(smartWifiMoreInfoViewModel.security)")
                Text("인터페이스 모드: \(smartWifiMoreInfoViewModel.interfaceMode)")
                Text("서비스 활성 상태: \(smartWifiMoreInfoViewModel.serviceActive ? "Active" : "Inactive")")
            }
            Section(header: Text("인터페이스 변경 관련 이벤트 내용")) {
                Text("이벤트 타입: \(smartWifiMoreInfoViewModel.eventType)")
                Text("이벤트 상세: \(smartWifiMoreInfoViewModel.eventDetails)")
            }
        }
        .ezBackgroundColorStyle()
        .navigationTitle(CategoryType.smartWifi.moreInfoTitle)
        .padding(30)
        .onDisappear {
            Logger.writeLog(.info, message: "SmartWifiMoreInfoView disappeared")
        }
    }
}
