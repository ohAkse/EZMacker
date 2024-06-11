//
//  InfoWifiMainView.swift
//  EZMacker
//
//  Created by 박유경 on 6/2/24.
//

import SwiftUI
import CoreWLAN

struct InfoWifiMainInfoView: View {
    @Binding var ssid: String
    @Binding var wifiLists: [ScaningWifiData]
    @State private var password: String = ""
    @State private var isShowingPasswordModal = false
    var appCoreWLanWifiService: AppCoreWLANWifiProvidable
    var onRefresh: () -> Void?
    var onWifiTap: (String, String) -> Void
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Image(systemName: "wifi.router.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer(minLength: 0)
                    Text("\(ssid)")
                        .customNormalTextFont(fontSize: FontSizeType.large.size, isBold: true)
                    Spacer()
                }
                .frame(width: 200, height: 300)
                .padding(40)
                Spacer()
                if wifiLists.isEmpty {
                    HStack(alignment: .center) {
                        ProgressView("Loading Wi-Fi Networks...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: 300, height: 300)
                    }
                    Spacer()
                } else {
                    VStack {
                        Spacer()
                        Button(action: {
                            didTapWifiListWithAscending()
                        }) {
                            Image(systemName: "arrowshape.up.fill")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .background(Color.clear)
                                .clipShape(Circle())
                        }
                        Spacer()
                        Button(action: {
                            didTapWifiListWithDescending()
                        }) {
                            Image(systemName: "arrowshape.down.fill")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .background(Color.clear)
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    
                    VStack(alignment: .center) {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                onRefresh()
                            }) {
                                Image(systemName: "rays")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .background(Color.clear)
                                    .clipShape(Circle())
                            }
                        }
                        .padding([.trailing], 20)
                        
                        List {
                            ForEach(wifiLists) { wifi in
                                HStack {
                                    Image(systemName: "wifi")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                    Text(wifi.ssid)
                                        .font(.headline)
                                    Spacer()
                                    Text("RSSI: \(wifi.rssi)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    ssid = wifi.ssid
                                    isShowingPasswordModal = true
                                }
                            }
                            .listRowBackground(Color.clear)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 3)
                        )
                        
                        .scrollContentBackground(.hidden)
                        .scrollClipDisabled(false)
                        .customBackgroundColor()
                        .padding()
                        Spacer()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .customBackgroundColor()
        .clipped()
        .sheet(isPresented: $isShowingPasswordModal) {
            AlertModalView(
                textFieldValue: $password,
                isPresented: $isShowingPasswordModal,
                ssid: ssid,
                title: "와이파이 접속",
                subtitle: "비밀번호를 입력해주세요.",
                onOk: {
                    onWifiTap(ssid, password)
                }
            )
        }

    }
    
    private func didTapWifiListWithAscending() {
        wifiLists = wifiLists.sorted { Int($0.rssi)! < Int($1.rssi)! }
    }
    
    private func didTapWifiListWithDescending() {
        wifiLists = wifiLists.sorted { Int($0.rssi)! > Int($1.rssi)! }
    }
}

#if DEBUG
struct InfoWifiMainInfoView_Previews: PreviewProvider {
    static var colorScheme = ColorSchemeViewModel()
    static var smartWifiService = AppSmartWifiService(serviceKey: "AppleBCMWLANSkywalkInterface")
    static var systemPreferenceService = SystemPreferenceService()
    static var appCoreWLanWifiService = AppCoreWLanWifiService(wifiClient: CWWiFiClient.shared(), wifyKeyChainService: AppWifiKeyChainService())
    
    @StateObject static var smartWifiViewModel = SmartWifiViewModel(
        appSmartWifiService: smartWifiService,
        systemPreferenceService: systemPreferenceService,
        appCoreWLanWifiService: appCoreWLanWifiService
    )

    @State static var ssid = "ABCD"
    @State static var wifiLists = [
        ScaningWifiData(ssid: "Network 1", rssi: "-70"),
        ScaningWifiData(ssid: "Network  2", rssi: "-60"),
        ScaningWifiData(ssid: "Network 3", rssi: "-80"),
        ScaningWifiData(ssid: "Network 4", rssi: "-60"),
        ScaningWifiData(ssid: "Network 5", rssi: "-80")
    ]
    
    static var previews: some View {
        InfoWifiMainInfoView(
            ssid: $ssid,
            wifiLists: $wifiLists,
            appCoreWLanWifiService: appCoreWLanWifiService,
            onRefresh: {},
            onWifiTap: { _, _ in }
        )
        .environmentObject(colorScheme)
        .environmentObject(smartWifiViewModel)
        .frame(width: 700, height: 700)
    }
}
#endif




