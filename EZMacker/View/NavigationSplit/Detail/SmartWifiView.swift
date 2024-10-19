//
//  AppSmartFileService.swift
//  EZMacker
//
//  Created by 박유경 on 9/1/24.
//

import SwiftUI
import CoreWLAN
import EZMackerServiceLib
import EZMackerUtilLib

struct SmartWifiView<ProvidableType>: View where ProvidableType: AppSmartWifiServiceProvidable {
    @EnvironmentObject var systemThemeService: SystemThemeService
    @StateObject private var smartWifiViewModel: SmartWifiViewModel<AppSmartWifiService>
    @State private var toast: ToastData?
    @State private var isRefreshing = false
    @State private var isFindingBestWifi = false
    @State private var isMoreInfo = false
    @State private var rotationDegrees: Double = 0
    @State private var navigationPath: [NavigationPathDestination] = []
    @Namespace private var animation
     
     init(factory: ViewModelFactory) {
         _smartWifiViewModel = StateObject(wrappedValue: factory.createSmartWifiViewModel())
     }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
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
                    case .notFoundSSID:
                        toast = ToastData(type: .error, message: wifiStatus.description)
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
                .onReceive(smartWifiViewModel.$isConnected) { isConnected in
                    if !isConnected && !navigationPath.isEmpty {
                        #if NO_NEED_MONITORING
                        navigationPath.removeLast()
                        #endif
                    }
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
            .navigationDestination(for: NavigationPathDestination.self) { destination in
                switch destination {
                case .wifiMoreInfo:
                    SmartWifiMoreInfoView(smartWifiMoreInfoViewModel: smartWifiViewModel.createMoreInfoViewModel())
                }
            }
        }
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
            Spacer(minLength: 10)
            EZWifiDetailView(band: $smartWifiViewModel.radioChannelData.band, hardwareAddress: $smartWifiViewModel.radioChannelData.macAddress, locale: $smartWifiViewModel.radioChannelData.locale)
                .frame(maxWidth: .infinity)
                .frame(height: geo.size.height / 4)
        }
        .frame(width: geo.size.width)
    }
    
    private func wifiMainInfoView(geo: GeometryProxy) -> some View {
        HStack(alignment: .center, spacing: 0) {
            ZStack {
                if !smartWifiViewModel.isConnected {
                    VStack {
                        EZLoadingView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ezBackgroundStyle()
                            .clipped()
                    }
                    .rotation3DEffect(
                        .degrees(rotationDegrees),
                        axis: (x: 0, y: 1, z: 0)
                    )
                } else {
                    VStack {
                        EZWifiMainView(
                            appSmartAutoconnectWifiService: AppSmartAutoconnectWifiService(),
                            ssid: $smartWifiViewModel.wificonnectData.connectedSSid,
                            wifiLists: $smartWifiViewModel.wificonnectData.scanningWifiList,
                            isRefreshing: $isRefreshing,
                            isFindingBestWifi: $isFindingBestWifi,
                            onRefresh: {
                                Task {
                                    isRefreshing = true
                                    smartWifiViewModel.fetchWifiListInfo()
                                    let status = smartWifiViewModel.getWifiRequestStatus()
                                    if status == .scanningFailed {
                                        toast = ToastData(type: .error, message: status.description)
                                    }
                                    isRefreshing = false
                                }
                            },
                            onWifiTap: { ssid, password in
                                Task {
                                    smartWifiViewModel.connectWifi(ssid: ssid, password: password)
                                }
                            },
                            onFindBestWifi: {
                                isFindingBestWifi = true
                                smartWifiViewModel.startSearchBestSSid {
                                    isFindingBestWifi = false
                                }
                            },
                            onMoreInfo: {
                                navigationPath.append(.wifiMoreInfo)
                            }
                        )
                    }
                    .rotation3DEffect(
                        .degrees(rotationDegrees),
                        axis: (x: 0, y: 1, z: 0)
                    )
                }
            }
            .animation(.easeInOut(duration: 1), value: smartWifiViewModel.isConnected)
        }
        .onChange(of: smartWifiViewModel.isConnected) { _, _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                rotationDegrees += 360
            }
        }
        .onAppear {
            DispatchQueue.global(qos: .userInitiated).async {
                smartWifiViewModel.fetchWifiListInfo()
                let status = smartWifiViewModel.getWifiRequestStatus()
                if status == .scanningFailed {
                    toast = ToastData(type: .error, message: status.description)
                }
            }
        }
    }
}
