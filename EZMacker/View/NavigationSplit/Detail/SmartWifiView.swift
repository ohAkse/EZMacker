import SwiftUI
import CoreWLAN

struct SmartWifiView<ProvidableType>: View where ProvidableType: AppSmartWifiServiceProvidable {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    @StateObject var smartWifiViewModel: SmartWifiViewModel<ProvidableType>
    @State private var toast: ToastData?

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                wifiDetailView(geo: geo)
                wifiMainInfoView(geo: geo)
                    .padding(.top, 20)
            }
            .onReceive(smartWifiViewModel.$wifiRequestStatus) { wifiStatus in
                if wifiStatus != .success && wifiStatus != .none {
                    toast = ToastData(type: .error, title: "에러", message: "와이파이를 접속할 수 없습니다. 비밀번호를 확인해주세요.", duration: 5)
                } else if wifiStatus == .success && wifiStatus != .none {
                    toast = ToastData(type: .info, title: "성공", message: "Wifi가 변경되었습니다", duration: 5)
                }
            }
            .onAppear {
                smartWifiViewModel.requestWifiInfo()
                smartWifiViewModel.startWifiTimer()
            }
            .onDisappear {
                smartWifiViewModel.stopWifiTimer()
            }
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
        .toastView(toast: $toast)
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
                .environmentObject(colorSchemeViewModel)
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
                        ssid: $smartWifiViewModel.wificonnectData.connectedSSid,
                        wifiLists: $smartWifiViewModel.wificonnectData.scanningWifiList,
                        appCoreWLanWifiService: AppCoreWLanWifiService(wifiClient: CWWiFiClient.shared(), wifyKeyChainService: AppWifiKeyChainService()),
                        onRefresh: {
                            Task {
                                await smartWifiViewModel.requestCoreWLanWifiInfo()
                                let status = smartWifiViewModel.getWifiRequestStatus()
                                if status == .scanningFailed {
                                    toast = ToastData(type: .error, title: "에러", message: "와이파이를 확인할 수 없습니다. 권한을 확인해주세요.", duration: 5)
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
            await smartWifiViewModel.requestCoreWLanWifiInfo()
            let status = smartWifiViewModel.getWifiRequestStatus()
            if status == .scanningFailed {
                toast = ToastData(type: .error, title: "에러", message: "와이파이를 확인할 수 없습니다. 권한을 확인해주세요.", duration: 5)
            }
        }
    }
}
