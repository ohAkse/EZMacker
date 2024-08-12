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
                    toast = ToastData(type: .error, title: "에러", message: "와이파이를 접속할 수 없습니다. 비밀번호를 확인해주세요.", duration: 10)
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
            EZArcIndicatorView(wifiStrength: $smartWifiViewModel.currentWifiStrength)
                .frame(maxWidth: .infinity)
                .frame(height: geo.size.height / 4)
                .environmentObject(colorSchemeViewModel)
            
            Spacer(minLength: 10)  

            EZChannelInfoView(channelBandwidth: $smartWifiViewModel.channelBandwidth, channelFrequency: $smartWifiViewModel.channelFrequency, channel: $smartWifiViewModel.channel)
                .frame(maxWidth: .infinity)
                .frame(height: geo.size.height / 4)
                .environmentObject(colorSchemeViewModel)
            
            Spacer(minLength: 10)

            EZWifiDetailView(band: $smartWifiViewModel.band, hardwareAddress: $smartWifiViewModel.currentHardwareAddress, locale: $smartWifiViewModel.locale)
                .frame(maxWidth: .infinity)
                .frame(height: geo.size.height / 4)
                .environmentObject(colorSchemeViewModel)
        }
        .frame(width: geo.size.width)  
    }

    // Wi-Fi 메인 정보 뷰
    private func wifiMainInfoView(geo: GeometryProxy) -> some View {
        HStack(alignment: .center, spacing: 0) {
            EZWifiMainInfoView(
                ssid: $smartWifiViewModel.ssID,
                wifiLists: $smartWifiViewModel.currentScanningWifiDataList,
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
                    smartWifiViewModel.connectWifi(ssid: ssid, password: password)
                },
                onFindBestWifi: {
                    smartWifiViewModel.startSearchBestSSid()
                }
            )
            .frame(width: geo.size.width , height: geo.size.height * 0.7)
            .environmentObject(colorSchemeViewModel)
            .task {
                await smartWifiViewModel.requestCoreWLanWifiInfo()
                let status = smartWifiViewModel.getWifiRequestStatus()
                if status == .scanningFailed {
                    toast = ToastData(type: .error, title: "에러", message: "와이파이를 확인할 수 없습니다. 권한을 확인해주세요.", duration: 5)
                }
            }
        }
    }
}

//#if DEBUG
//struct SmartWifiView_Previews: PreviewProvider {
//    static var colorSchemeViewModel = ColorSchemeViewModel()
//    static var smartWifiService = AppSmartWifiService(serviceKey: "AppleBCMWLANSkywalkInterface")
//    static var systemPreferenceService = SystemPreferenceService()
//    static var appCoreWLanWifiService = AppCoreWLanWifiService(wifiClient: CWWiFiClient.shared(), wifyKeyChainService: AppWifiKeyChainService())
//    static var appSettingService = AppSmartSettingsService()
//    @StateObject static var smartWifiViewModel = SmartWifiViewModel(
//        appSmartWifiService: smartWifiService,
//        systemPreferenceService: systemPreferenceService,
//        appCoreWLanWifiService: appCoreWLanWifiService,
//        appSettingService: appSettingService
//    )
//    
//    static var previews: some View {
//        SmartWifiView(smartWifiViewModel: smartWifiViewModel)
//            .environmentObject(colorSchemeViewModel)
//            .frame(width: 700, height: 1000)
//    }
//}
//#endif

