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
            connectionInfoSection
            radioChannelInfoSection
            interfaceInfoSection
            ForEach(smartWifiMoreInfoViewModel.interfaces, id: \.name) { interface in
                networkInterfaceSection(for: interface)
            }
            multicastInfoSection
            eventInfoSection
            #if !USE_PRIVATE_FUNC
            commandListSection
            #endif
        }
        .ezBackgroundStyle()
        .navigationTitle(CategoryType.smartWifi.moreInfoTitle)
        .padding(30)
        .onDisappear {
            Logger.writeLog(.info, message: "SmartWifiMoreInfoView disappeared")
        }
    }
    
    private var connectionInfoSection: some View {
        Section(header: Text("연결 정보")) {
            Text("SSID: \(smartWifiMoreInfoViewModel.wificonnectData.connectedSSid)")
            Text("신호 강도: \(smartWifiMoreInfoViewModel.wificonnectData.strength)dBM")
            Text("전송 속도: \(smartWifiMoreInfoViewModel.wificonnectData.transmitRate)")
            Text("비콘 간격: \(smartWifiMoreInfoViewModel.beaconInterval)")
        }
    }
    
    private var radioChannelInfoSection: some View {
        Section(header: Text("라디오 채널 정보")) {
            Text("대역폭: \(smartWifiMoreInfoViewModel.radioChannelData.channelBandwidth)MHz")
            Text("주파수: \(smartWifiMoreInfoViewModel.radioChannelData.channelFrequency)MHz")
            Text("채널: \(smartWifiMoreInfoViewModel.radioChannelData.channel)")
            Text("대역: \(smartWifiMoreInfoViewModel.radioChannelData.band)")
            Text("MAC 주소: \(smartWifiMoreInfoViewModel.radioChannelData.macAddress)")
            Text("지역: \(smartWifiMoreInfoViewModel.radioChannelData.locale)")
        }
    }
    
    private var interfaceInfoSection: some View {
        Section(header: Text("인터페이스 정보")) {
            Text("인터페이스 이름: \(smartWifiMoreInfoViewModel.wificonnectData.interfaceName)")
            Text("활성 PHY 모드: \(smartWifiMoreInfoViewModel.wificonnectData.activePHYMode)")
            Text("전원 상태: \(smartWifiMoreInfoViewModel.wificonnectData.powerOn ? "On" : "Off")")
            Text("지원되는 WLAN 채널: \(smartWifiMoreInfoViewModel.wificonnectData.supportedWLANChannels.joined(separator: ", "))")
            Text("BSSID: \(smartWifiMoreInfoViewModel.wificonnectData.bssid)")
            Text("잡음 측정: \(smartWifiMoreInfoViewModel.wificonnectData.noiseMeasurement)dBm")
            Text("보안 모드: \(smartWifiMoreInfoViewModel.wificonnectData.security)")
            Text("인터페이스 모드: \(smartWifiMoreInfoViewModel.wificonnectData.interfaceMode)")
            Text("서비스 활성 상태: \(smartWifiMoreInfoViewModel.wificonnectData.serviceActive ? "Active" : "Inactive")")
        }
    }
    
    private func networkInterfaceSection(for interface: NetworkInterfaceData) -> some View {
        Section(header: Text("\(interface.name) 인터페이스 정보")) {
            Text("상태: \(interface.status)")
            Text("MAC 주소: \(interface.ethernetAddress)")
            
            if !interface.ipv4.address.isEmpty {
                Text("IPv4 주소: \(interface.ipv4.address)")
                Text("서브넷 마스크: \(interface.ipv4.subnetMask)")
                Text("브로드캐스트: \(interface.ipv4.broadcast)")
            }
            
            if !interface.ipv6.address.isEmpty {
                Text("IPv6 주소: \(interface.ipv6.address)")
                Text("프리픽스 길이: \(interface.ipv6.prefixLength)")
                Text("스코프 ID: \(interface.ipv6.scopeID)")
            }
            
            Text("미디어: \(interface.media)")
        }
    }
    private var multicastInfoSection: some View {
        Section(header: Text("멀티캐스트 정보")) {
            ForEach(smartWifiMoreInfoViewModel.interfaceMulticastInfo.sorted(by: { $0.key < $1.key }), id: \.key) { interface, enabled in
                Text("\(interface) 멀티캐스트: \(enabled ? "활성화" : "비활성화")")
            }
        }
    }
    private var commandListSection: some View {
        Section(header: Text("명령어 리스트 (비공개)")) {
            ForEach(smartWifiMoreInfoViewModel.commandList, id: \.self) { command in
                Text(command)
            }
            Text("*224.0.0.1(All Hosts MultiCast Group), 224.0.0.251(mDNS Multicast Address)")
                .foregroundColor(.red)
        }
    }
    private var eventInfoSection: some View {
        Section(header: Text("인터페이스 변경 관련 이벤트 내용")) {
            Text("이벤트 타입: \(smartWifiMoreInfoViewModel.eventType)")
            Text("이벤트 상세: \(smartWifiMoreInfoViewModel.eventDetails)")
        }
    }
}
