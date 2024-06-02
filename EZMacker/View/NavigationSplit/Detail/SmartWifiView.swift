import SwiftUI

struct SmartWifiView<ProvidableType>: View where ProvidableType: AppSmartWifiServiceProvidable {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    @ObservedObject var smartWifiViewModel: SmartWifiViewModel<ProvidableType>
    
    init(smartWifiViewModel: SmartWifiViewModel<ProvidableType>) {
        self.smartWifiViewModel = smartWifiViewModel
    }
    
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
                    InfoSSidInfoView(band: $smartWifiViewModel.band, ssID: $smartWifiViewModel.ssID, locale: $smartWifiViewModel.locale)
                        .frame(width: geo.size.width * 0.3, height: geo.size.height / 4)
                        .environmentObject(colorSchemeViewModel)
                }
                HStack(alignment: .top, spacing: 0) {
                      InfoWifiMainInfoView()
                        .frame(width: geo.size.width  , height: geo.size.height * 0.7)
                          .environmentObject(colorSchemeViewModel)
                  }
                .padding(.top, 20)
            }
            .onAppear {
                smartWifiViewModel.requestWifiInfo()
                smartWifiViewModel.requestCoreWLanWifiInfo()
                smartWifiViewModel.startWifiTimer()
            }
            .onDisappear() {
                smartWifiViewModel.stopWifiTimer()
            }
        }
        .padding(30)
    }
}

