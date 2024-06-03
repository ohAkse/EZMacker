import SwiftUI

struct SmartWifiView<ProvidableType>: View where ProvidableType: AppSmartWifiServiceProvidable {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    @StateObject var smartWifiViewModel: SmartWifiViewModel<ProvidableType>
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                HStack(alignment:. top, spacing:0) {
                    InfoArcIndicatorView(wifiStrength: $smartWifiViewModel.currentWifiStrength)
                        .frame(width: geo.size.width * 0.3, height: geo.size.height/4)
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
                    InfoWifiMainInfoView(ssid: $smartWifiViewModel.ssID, wifiLists: $smartWifiViewModel.currentScanningWifiDataList, onRefresh: {
                        Task {
                            await smartWifiViewModel.requestCoreWLanWifiInfo()
                        }
                        })
                        .frame(width: geo.size.width  , height: geo.size.height * 0.7)
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
            .onDisappear() {
                smartWifiViewModel.stopWifiTimer()
            }
        }
        .padding(30)
    }
}

