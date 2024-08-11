import SwiftUI

struct SmartNotificationAlarmView: View {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    @ObservedObject var smartNotificationAlarmViewModel: SmartNotificationAlarmViewModel
    @State private var toast: Toast?
    
    // 배터리 섹션 뷰
    private var batterySectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("배터리")
                .customNormalTextFont(fontSize: FontSizeType.medium.size, isBold: true)
                .padding(.top, 10)
            
            Picker("CPU 과사용시 종료하기", selection: $smartNotificationAlarmViewModel.selectedAppExitOption) {
                ForEach(AppUsageExitOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("배터리 상태 (0-100%)")
                    TextFieldRepresentableView(text: $smartNotificationAlarmViewModel.batteryPercentage)
                        .padding(5)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
            
            Toggle(isOn: $smartNotificationAlarmViewModel.isBattryCurrentMessageMode) {
                Text("배터리 상태 설정된 값이 완료됐을 시 알람 울리기")
            }
            .toggleStyle(CheckboxToggleStyle())
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            
            Toggle(isOn: $smartNotificationAlarmViewModel.isBatteryWarningMode) {
                Text("배터리 충전 안될 시 알람 울리기")
            }
            .toggleStyle(CheckboxToggleStyle())
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    // 와이파이 섹션 뷰
    private var wifiSectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("와이파이")
                .customNormalTextFont(fontSize: FontSizeType.medium.size, isBold: true)
                .padding(.top, 10)
            
            HStack {
                Picker("최적의 와이파이 발견 시 알림으로 표시하기", selection: $smartNotificationAlarmViewModel.selectedBestSSidOption) {
                    ForEach(BestSSIDShowOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    // 저장 버튼 뷰
    private var saveButtonView: some View {
        HStack {
            Spacer()
            Button(action: {
                smartNotificationAlarmViewModel.saveConfig()
                toast = Toast(type: .info, title: "정보", message: "저장이 완료되었습니다.", duration: 3)
            }) {
                Text("확인")
                    .padding()
                    .buttonStyle(.bordered)
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color.blue)
            .customBackgroundColor()
        }
        .padding(.top, 10)
    }
    
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
        .preferredColorScheme(colorSchemeViewModel.colorScheme == ColorSchemeMode.Dark.title ? .dark : .light)
        .toastView(toast: $toast)
        .padding(30)
    }
}
