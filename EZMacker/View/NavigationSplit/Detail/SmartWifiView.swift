//
//  AppSmartFileService.swift
//  EZMacker
//
//  Created by 박유경 on 9/1/24.
//

import SwiftUI
import CoreWLAN
import EZMackerServiceLib

struct SmartWifiView<ProvidableType>: View where ProvidableType: AppSmartWifiServiceProvidable {
    @EnvironmentObject var appThemeManager: SystemThemeService
    @StateObject private var smartWifiViewModel: SmartWifiViewModel<AppSmartWifiService>
    @State private var toast: ToastData?
    
    init(factory: ViewModelFactory) {
        _smartWifiViewModel = StateObject(wrappedValue: factory.createSmartWifiViewModel())
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                wifiDetailView(geo: geo)
                wifiMainInfoView(geo: geo)
                    .padding(.top, 20)
            }
            .onReceive(smartWifiViewModel.$wifiRequestStatus) { wifiStatus in
                switch wifiStatus {
                case .none:
                    break
                case .success:
                    toast = ToastData(type: .info, message: wifiStatus.description)
                case .disconnected:
                    toast = ToastData(type: .warning, message: wifiStatus.description)
                default:
                    toast = ToastData(type: .error, message: wifiStatus.description)
                }
            }
            .onAppear {
                smartWifiViewModel.startMonitoring()
                smartWifiViewModel.startWifiTimer()
            }
            .onDisappear {
                smartWifiViewModel.stopWifiTimer()
            }
            .toastView(toast: $toast)
        }
        .sheet(isPresented: $smartWifiViewModel.showAlert) {
            AlertOKCancleView(
                isPresented: $smartWifiViewModel.showAlert,
                title: "최적의 와이파이",
                subtitle: "결과",
                content: smartWifiViewModel.bestSSid
            )
        }
        .navigationTitle(CategoryType.smartWifi.title)
        .padding(30)
        
    }
    
    // Wi-Fi 세부 정보 뷰
    private func wifiDetailView(geo: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            EZWifiStrengthView(wifiStrength: $smartWifiViewModel.wificonnectData.strength)
                .frame(maxWidth: .infinity)
                .frame(height: geo.size.height / 4)
            Spacer(minLength: 10)
            EZWifiChannelView(channelBandwidth: $smartWifiViewModel.radioChannelData.channelBandwidth, channelFrequency: $smartWifiViewModel.radioChannelData.channelFrequency, channel: $smartWifiViewModel.radioChannelData.channel)
                .frame(maxWidth: .infinity)
                .frame(height: geo.size.height / 4)
                .environmentObject(appThemeManager)
            Spacer(minLength: 10)
            EZWifiDetailView(band: $smartWifiViewModel.radioChannelData.band, hardwareAddress: $smartWifiViewModel.radioChannelData.macAddress, locale: $smartWifiViewModel.radioChannelData.locale)
                .frame(maxWidth: .infinity)
                .frame(height: geo.size.height / 4)
        }
        .frame(width: geo.size.width)  
    }
    
    // Wi-Fi 메인 정보 뷰
    private func wifiMainInfoView(geo: GeometryProxy) -> some View {
        HStack(alignment: .center, spacing: 0) {
            if smartWifiViewModel.isConnecting {
                VStack {
                    Spacer()
                    EZLoadingView()
                    Spacer()
                }
            } else {
                AnyView(
                    EZWifiMainView(
                        appSmartAutoconnectWifiService: AppSmartAutoconnectWifiService(),
                        ssid: $smartWifiViewModel.wificonnectData.connectedSSid,
                        wifiLists: $smartWifiViewModel.wificonnectData.scanningWifiList,
                        onRefresh: {
                            Task {
                                await smartWifiViewModel.fetchWifiListInfo()
                                let status = smartWifiViewModel.getWifiRequestStatus()
                                if status == .scanningFailed {
                                    toast = ToastData(type: .error, message: status.description)
                                }
                            }
                        },
                        onWifiTap: { ssid, password in
                            Task {
                                smartWifiViewModel.isConnecting = true
                                await smartWifiViewModel.connectWifi(ssid: ssid, password: password)
                                smartWifiViewModel.isConnecting = false
                            }
                        },
                        onFindBestWifi: {
                            smartWifiViewModel.startSearchBestSSid()
                        }
                    )
                )
            }
        }
        .task {
            await smartWifiViewModel.fetchWifiListInfo()
            let status = smartWifiViewModel.getWifiRequestStatus()
            if status == .scanningFailed {
                toast = ToastData(type: .error, message: status.description)
            }
        }
    }
}
