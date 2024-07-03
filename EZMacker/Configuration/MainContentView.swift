import SwiftUI
import CoreWLAN
struct MainContentView: View {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    @State private var selectionValue = CategoryType.smartFile
    
    var body: some View {
        NavigationSplitView {
            CategoryView(selectionValue: $selectionValue)
                .frame(minWidth: 200)
                .contentShape(Rectangle())
        } detail: {
            GeometryReader { geometry in
                switch selectionValue {
                case .smartBattery:
                    SmartBatteryView(smartBatteryViewModel: SmartBatteryViewModel<AppSmartBatteryService>(appSmartBatteryService: AppSmartBatteryService(serviceKey: "AppleSmartBattery"),appSettingService: AppSmartSettingsService(),appProcessService: AppSmartProcessService(), systemPreferenceService: SystemPreferenceService()))
                        .environmentObject(colorSchemeViewModel)
                case .smartWifi:
                    SmartWifiView(smartWifiViewModel: SmartWifiViewModel<AppSmartWifiService>(appSmartWifiService: AppSmartWifiService(serviceKey: "AppleBCMWLANSkywalkInterface"), systemPreferenceService: SystemPreferenceService(), appCoreWLanWifiService: AppCoreWLanWifiService(wifiClient: CWWiFiClient.shared(),wifyKeyChainService: AppWifiKeyChainService()), appSettingService: AppSmartSettingsService()))
                        .environmentObject(colorSchemeViewModel)
                case .smartFile:
                    SmartFileView(smartFileViewModel: SmartFileViewModel(appSmartFileService: AppSmartFileService(), systemPreferenceService: SystemPreferenceService()))
                        .environmentObject(colorSchemeViewModel)
                case .smartNotificationAlarm:
                    SmartNotificationAlarmView(smartNotificationAlarmViewModel: SmartNotificationAlarmViewModel(appSettingService: AppSmartSettingsService(), appProcessService: AppSmartProcessService()))
                        .environmentObject(colorSchemeViewModel)
                }
            }
            
        }
        .toolbar(id: ToolbarKey.MainToolbar.name) {
            ToolbarItem(id: ToolbarKey.ColorSchemePicker.name, placement: .primaryAction) {
                HStack(spacing: 0) {
                    ColorSchemeToolbarView(buttonTitle: ColorSchemeMode.Light.title, buttonTag: ColorSchemeMode.Light.tag)
                    ColorSchemeToolbarView(buttonTitle: ColorSchemeMode.Dark.title, buttonTag: ColorSchemeMode.Dark.tag)
                }
                .padding(3)
                .overlay {
                    Capsule()
                        .stroke(.blue, lineWidth: 1)
                }
                .opacity(colorSchemeViewModel.isShowChooseColorScheme ? 1 : 0)
                .animation(.linear(duration: 0.2), value: colorSchemeViewModel.rotateDegree)
            }
            
            ToolbarItem(id: ToolbarKey.ColorSchemeButton.name, placement: .primaryAction) {
                Button {
                    colorSchemeViewModel.toggleColorScheme()
                } label: {
                    Image(systemName: ToolbarImage.colorSchemeButton.systemName)
                        .rotationEffect(.degrees(colorSchemeViewModel.rotateDegree))
                        .animation(.linear(duration: 0.2), value: colorSchemeViewModel.rotateDegree)
                }
            }
        }
        .preferredColorScheme(colorSchemeViewModel.colorScheme == ColorSchemeMode.Dark.title ? .dark : .light)
    }
}
