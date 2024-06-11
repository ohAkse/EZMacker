import SwiftUI
import CoreWLAN

struct SmartWifiView<ProvidableType>: View where ProvidableType: AppSmartWifiServiceProvidable {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    @StateObject var smartWifiViewModel: SmartWifiViewModel<ProvidableType>
    @State private var isShowAlert = false
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack(alignment: .top, spacing: 0) {
                    InfoArcIndicatorView(wifiStrength: $smartWifiViewModel.currentWifiStrength)
                        .frame(width: geo.size.width * 0.3, height: geo.size.height / 4)
                        .environmentObject(colorSchemeViewModel)
                    Spacer(minLength: 5)
                    InfoChannelInfoView(channelBandwidth: $smartWifiViewModel.channelBandwidth, channelFrequency: $smartWifiViewModel.channelFrequency, channel: $smartWifiViewModel.channel)
                        .frame(width: geo.size.width * 0.3, height: geo.size.height / 4)
                        .environmentObject(colorSchemeViewModel)
                    Spacer(minLength: 5)
                    InfoWifiDetailView(band: $smartWifiViewModel.band, hardwareAddress: $smartWifiViewModel.currentHardwareAddress, locale: $smartWifiViewModel.locale)
                        .frame(width: geo.size.width * 0.3, height: geo.size.height / 4)
                        .environmentObject(colorSchemeViewModel)
                }
                HStack(alignment: .top, spacing: 0) {
                    InfoWifiMainInfoView(
                        ssid: $smartWifiViewModel.ssID,
                        wifiLists: $smartWifiViewModel.currentScanningWifiDataList,
                        appCoreWLanWifiService: AppCoreWLanWifiService(wifiClient: CWWiFiClient.shared(), wifyKeyChainService: AppWifiKeyChainService()),
                        onRefresh: {
                            Task {
                                await smartWifiViewModel.requestCoreWLanWifiInfo()
                            }
                        },
                        onWifiTap: { ssid, password in
                            Logger.writeLog(.info, message: "\(ssid), \(password)")
                            smartWifiViewModel.connectWifi(ssid: ssid)
                        }
                    )
                    .frame(width: geo.size.width, height: geo.size.height * 0.7)
                    .environmentObject(colorSchemeViewModel)
                    .task {
                        await smartWifiViewModel.requestCoreWLanWifiInfo()
                    }
                }
                .padding(.top, 20)
            }
            .onAppear {
                smartWifiViewModel.requestWifiInfo()
                smartWifiViewModel.startWifiTimer()
            }
            .onDisappear {
                smartWifiViewModel.stopWifiTimer()
            }
        }
        .padding(30)
    }
}

struct SmartWifiView_Previews: PreviewProvider {
    static var colorSchemeViewModel = ColorSchemeViewModel()
    static var smartWifiService = AppSmartWifiService(serviceKey: "AppleBCMWLANSkywalkInterface")
    static var systemPreferenceService = SystemPreferenceService()
    static var appCoreWLanWifiService = AppCoreWLanWifiService(wifiClient: CWWiFiClient.shared(), wifyKeyChainService: AppWifiKeyChainService())
    
    @StateObject static var smartWifiViewModel = SmartWifiViewModel(
        appSmartWifiService: smartWifiService,
        systemPreferenceService: systemPreferenceService,
        appCoreWLanWifiService: appCoreWLanWifiService
    )
    
    static var previews: some View {
        SmartWifiView(smartWifiViewModel: smartWifiViewModel)
            .environmentObject(colorSchemeViewModel)
            .frame(width: 700, height: 1000)
    }
}


