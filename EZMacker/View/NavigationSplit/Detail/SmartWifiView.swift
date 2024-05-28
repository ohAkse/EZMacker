import SwiftUI

struct SmartWifiView<ProvidableType>: View where ProvidableType: AppSmartWifiServiceProvidable {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    @ObservedObject var smartWifiViewModel: SmartWifiViewModel<ProvidableType>
    
    init(smartWifiViewModel: SmartWifiViewModel<ProvidableType>) {
        self.smartWifiViewModel = smartWifiViewModel
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                VStack() {
                    InfoArcIndicatorView(wifiStrength: $smartWifiViewModel.currentWifiStrength)
                        .frame(width: geo.size.width/3, height: geo.size.width/5)

                }
                Spacer()
            }
            .onAppear {
                smartWifiViewModel.requestWifiInfo()
                smartWifiViewModel.requestCoreWLanWifiInfo()
            }
        }
        .padding(40)
    }
}

