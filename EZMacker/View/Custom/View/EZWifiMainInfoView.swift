import SwiftUI
import CoreWLAN

struct EZWifiMainInfoView: View {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    @Binding var ssid: String
    @Binding var wifiLists: [ScaningWifiData]
    @State private var password: String = ""
    @State private var isShowingPasswordModal = false
    @State private var toast: ToastData?
    var appCoreWLanWifiService: AppCoreWLANWifiProvidable
    var onRefresh: () -> Void
    var onWifiTap: (String, String) -> Void
    var onFindBestWifi: () -> Void
    
    
    var body: some View {
        VStack {
            HStack {
                VStack() {
                    Image(systemName: "wifi.router.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer(minLength: 0)
                    Text("\(ssid)")
                        .ezNormalTextStyle(colorSchemeMode: colorSchemeViewModel.getColorScheme(), fontSize: FontSizeType.large.size, isBold: true)
                    Spacer()
                }
                .frame(width: 200, height: 300)
                .padding([.leading, .trailing], 20)
                .padding(.top, 60)
                
                Spacer()
                if wifiLists.isEmpty {
                    HStack(alignment: .center) {
                        ProgressView("Loading Wi-Fi Networks...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: 300, height: 300)
                    }
                    Spacer()
                } else {
                    VStack(spacing:0) {
                        Spacer()
                        Button(action: {
                            didTapWifiListWithAscending()
                        }) {}
                            .ezButtonImageStyle(imageName: "arrowshape.up.fill")
                        Spacer()
                        Button(action: {
                            didTapWifiListWithDescending()
                        }) {}
                            .ezButtonImageStyle(imageName: "arrowshape.down.fill")
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                onRefresh()
                            }) {}
                                .ezButtonImageStyle(imageName: "rays")
                                .padding(.trailing, 5)
                            Button(action: {
                                onFindBestWifi()
                                toast = ToastData(type: .info, title: "정보", message: "최적의 와이파이를 찾고 있습니다.")
                                
                            }) {}
                                .ezButtonImageStyle(imageName: "arrow.clockwise.circle")
                        }
                        .padding([.trailing], 10)
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
                            .ezListRowStyle()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray, lineWidth: 3)
                        )
                        .scrollContentBackground(.hidden)
                        .scrollClipDisabled(false)
                        .ezBackgroundColorStyle()
                        .padding(10)
                    }
                    .ezListViewStyle()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ezBackgroundColorStyle()
        .clipped()
        .sheet(isPresented: $isShowingPasswordModal) {
            AlertTextFieldView(
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
        .toastView(toast: $toast)
    }
    
    private func didTapWifiListWithAscending() {
        wifiLists = wifiLists.sorted { Int($0.rssi)! < Int($1.rssi)! }
    }
    
    private func didTapWifiListWithDescending() {
        wifiLists = wifiLists.sorted { Int($0.rssi)! > Int($1.rssi)! }
    }
}

//#if DEBUG
//struct InfoWifiMainInfoView_Previews: PreviewProvider {
//    static var colorScheme = ColorSchemeViewModel()
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
//    @State static var ssid = "ABCD"
//    @State static var wifiLists = [
//        ScaningWifiData(ssid: "Network 1", rssi: "-70"),
//        ScaningWifiData(ssid: "Network  2", rssi: "-60"),
//        ScaningWifiData(ssid: "Network 3", rssi: "-80"),
//        ScaningWifiData(ssid: "Network 4", rssi: "-60"),
//        ScaningWifiData(ssid: "Network 5", rssi: "-80")
//    ]
//
//    static var previews: some View {
//        InfoWifiMainInfoView(
//            ssid: $ssid,
//            wifiLists: $wifiLists,
//            appCoreWLanWifiService: appCoreWLanWifiService,
//            onRefresh: {},
//            onWifiTap: { _, _ in },
//            onFindBestWifi: {}
//        )
//        .environmentObject(colorScheme)
//        .environmentObject(smartWifiViewModel)
//        .frame(width: 700, height: 700)
//    }
//}
//#endif
