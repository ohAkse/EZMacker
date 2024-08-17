import SwiftUI
import CoreWLAN
struct MainContentView: View {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    @State private var selectionValue = CategoryType.smartFileSearch
    
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
                case .smartNotificationAlarm:
                    SmartNotificationAlarmView(smartNotificationAlarmViewModel: SmartNotificationAlarmViewModel(appSettingService: AppSmartSettingsService(), appProcessService: AppSmartProcessService(), batterySetting:BatterySetting(), wifiSetting: WifiSetting(), fileLocatorSetting: FileLocatorSetting()))
                        .environmentObject(colorSchemeViewModel)
                case .smartFileLocator:
                        SmartFileLocatorView(smartFileLocatorViewModel: SmartFileLocatorViewModel(appSmartFileService: AppSmartFileService(), appSmartFileMonitor: AppSmartFileMonitorService(), appSmartSettingService: AppSmartSettingsService()))
                        .environmentObject(colorSchemeViewModel)
                case .smartFileSearch:
                    SmartFileSearchView(smartFileSearchViewModel: SmartFileSearchViewModel())
                        .environmentObject(colorSchemeViewModel)
                }
            }
            
        }
        .toolbar(id: ToolbarKeyType.MainToolbar.name) {
            ToolbarItem(id: ToolbarKeyType.ColorSchemePicker.name, placement: .primaryAction) {
                HStack(spacing: 0) {
                    ColorSchemeToolbarView(buttonTitle: ColorSchemeModeType.Light.title, buttonTag: ColorSchemeModeType.Light.tag)
                    ColorSchemeToolbarView(buttonTitle: ColorSchemeModeType.Dark.title, buttonTag: ColorSchemeModeType.Dark.tag)
                }
                .padding(3)
                .overlay {
                    Capsule()
                        .stroke(.blue, lineWidth: 1)
                }
                .opacity(colorSchemeViewModel.isShowChooseColorScheme ? 1 : 0)
                .animation(.linear(duration: 0.2), value: colorSchemeViewModel.rotateDegree)
            }
            
            ToolbarItem(id: ToolbarKeyType.ColorSchemeButton.name, placement: .primaryAction) {
                Button {
                    colorSchemeViewModel.toggleColorScheme()
                } label: {
                    Image(systemName: ToolbarImage.colorSchemeButton.systemName)
                        .rotationEffect(.degrees(colorSchemeViewModel.rotateDegree))
                        .animation(.linear(duration: 0.2), value: colorSchemeViewModel.rotateDegree)
                }
            }
        }
        .preferredColorScheme(colorSchemeViewModel.colorScheme == ColorSchemeModeType.Dark.title ? .dark : .light)
    }
}
