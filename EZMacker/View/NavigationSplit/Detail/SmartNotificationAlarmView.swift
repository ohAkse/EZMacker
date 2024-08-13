import SwiftUI

struct SmartNotificationAlarmView: View {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    @StateObject var smartNotificationAlarmViewModel: SmartNotificationAlarmViewModel
    @State private var toast: ToastData?
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView {
                batterySectionView
                wifiSectionView
            }
            saveButtonView
        }
        .onAppear {
            smartNotificationAlarmViewModel.loadConfig()
        }
        .navigationTitle(CategoryType.smartNotificationAlarm.title)
        .toastView(toast: $toast)
        .padding(30)
    }
    
    // 배터리 섹션 뷰
    private var batterySectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("배터리")
                .ezNormalTextStyle(colorSchemeMode: colorSchemeViewModel.getColorScheme(), fontSize: FontSizeType.medium.size, isBold: true)
                .padding(.top, 10)
            
            Picker("CPU 과사용시 종료하기", selection: $smartNotificationAlarmViewModel.selectedAppExitOption) {
                ForEach(AppUsageExitOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .ezInnerBackgroundStyle()
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("배터리 상태 (0-100%)")
                    TextFieldRepresentableView(text: $smartNotificationAlarmViewModel.batteryPercentage)
                        .ezTextFieldWrapperStyle() // 디폴트 스타일 비슷하게 따라함(통일성)
                }
                .padding()
                .ezInnerBackgroundStyle()
            }
            
            Toggle(isOn: $smartNotificationAlarmViewModel.isBattryCurrentMessageMode) {
                Text("배터리 상태 설정된 값이 완료됐을 시 알람 울리기")
            }
            .toggleStyle(CheckboxToggleStyle())
            .padding()
            .ezInnerBackgroundStyle()
            
            Toggle(isOn: $smartNotificationAlarmViewModel.isBatteryWarningMode) {
                Text("배터리 충전 안될 시 알람 울리기")
            }
            .toggleStyle(CheckboxToggleStyle())
            .padding()
            .ezInnerBackgroundStyle()
        }
        .padding()
        .ezBackgroundColorStyle()
    }
    
    // 와이파이 섹션 뷰
    private var wifiSectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("와이파이")
                .ezNormalTextStyle(colorSchemeMode: colorSchemeViewModel.getColorScheme(), fontSize: FontSizeType.medium.size, isBold: true)
                .padding(.top, 10)
            
            HStack {
                Picker("최적의 와이파이 발견 시 알림으로 표시하기", selection: $smartNotificationAlarmViewModel.selectedBestSSidOption) {
                    ForEach(BestSSIDShowOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            }
            .padding()
            .ezInnerBackgroundStyle()
        }
        .padding()
        .ezBackgroundColorStyle()
    }
    
    // 저장 버튼 뷰
    private var saveButtonView: some View {
        HStack {
            Spacer()
            Button("확인") {
                smartNotificationAlarmViewModel.saveConfig()
                toast = ToastData(type: .info, title: "정보", message: "저장이 완료되었습니다.", duration: 3)
            }
            .frame(width: 55, height: 45)
            .ezButtonStyle()
        }
        .padding(.top, 10)
    }
}
