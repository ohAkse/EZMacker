import SwiftUI

struct MainContentView: View {
    @AppStorage(AppStorageKey.colorSchme.name) var colorScheme = AppStorageKey.colorSchme.byDefault
    @State private var selectionValue = CategoryType.smartBattery
    @State private var isShowChooseColorScheme = false
    @State private var rotateDegree = 0
    
    var body: some View {
        NavigationSplitView {
            CategoryView(selectionValue: $selectionValue)
                .frame(minWidth: 200)
                
        } detail: {
            GeometryReader { geo in 
                switch selectionValue {
                case .smartBattery:
                    SmartBatteryView(smartBatteryViewModel: SmartBatteryViewModel(appSmartBatteryService: AppSmartBatteryService(), systemPreferenceService: SystemPreferenceService()))
                case .smartFile:
                    SmartFileView(smartFileViewModel: SmartFileViewModel(appSmartFileService: AppSmartFileService(), systemPreferenceService: SystemPreferenceService()))
                case .notificationAlarm:
                    NotificationAlarmView(notificationAlarmViewModel: NotificationAlarmViewModel())
                }
            }
        }
        .toolbar(id: ToolbarKey.MainToolbar.name) {
            ToolbarItem(id: ToolbarKey.ColorSchemePicker.name, placement: .primaryAction) {
                HStack(spacing: 0) {
                    ColorSchemeToolbarView(buttonTitle: ColorSchemeMode.Light.title, buttonTag: ColorSchemeMode.Light.tag)
                    ColorSchemeToolbarView(buttonTitle: ColorSchemeMode.Dark.title, buttonTag: ColorSchemeMode.Dark.tag )
                    
                }
                .padding(3)
                .overlay {
                    Capsule()
                        .stroke(.blue, lineWidth: 1)
                }
                .opacity(isShowChooseColorScheme ? 1 : 0)
                .animation(.linear(duration: 0.2), value: rotateDegree)
            }
            
            ToolbarItem(id: ToolbarKey.ColorSchemeButton.name, placement: .primaryAction) {
                Button {
                    withAnimation(.linear) {
                        isShowChooseColorScheme.toggle()
                        rotateDegree = rotateDegree == 0 ? -180 : 0
                    }
                } label: {
                    Image(systemName: ToolbarImage.colorSchemeButton.systemName)
                        .rotationEffect(.degrees(Double(rotateDegree)))
                        .animation(.linear(duration: 0.2), value: rotateDegree)
                }
            }
        }
        
        .preferredColorScheme(colorScheme == ColorSchemeMode.Dark.title ? .dark : .light)
    }
}
