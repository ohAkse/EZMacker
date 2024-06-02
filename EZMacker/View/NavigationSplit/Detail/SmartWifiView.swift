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
                    Spacer(minLength: 10)
                    InfoArcIndicatorView(wifiStrength: $smartWifiViewModel.currentWifiStrength)
                        .frame(width: geo.size.width * 0.3, height: geo.size.height/4)
                        .environmentObject(colorSchemeViewModel)
                    Spacer(minLength: 10)
                    InfoArcIndicatorView(wifiStrength: $smartWifiViewModel.currentWifiStrength)
                        .frame(width: geo.size.width * 0.3, height: geo.size.height/4)
                        .environmentObject(colorSchemeViewModel)
                    Spacer(minLength: 10)
                    InfoArcIndicatorView(wifiStrength: $smartWifiViewModel.currentWifiStrength)
                        .frame(width: geo.size.width * 0.3, height: geo.size.height/4)
                        .environmentObject(colorSchemeViewModel)
                    Spacer(minLength: 10)
                }
                HStack(alignment: .center, spacing:0 ) {
                    Rectangle()
                        .frame(width: geo.size.width * 0.95,  height: geo.size.height * 0.7)
                        .customBackgroundColor()
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

        .padding(20)
    }
}

