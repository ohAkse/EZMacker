import SwiftUI

struct SmartNotificationAlarmView: View {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    @ObservedObject var smartNotificationAlarmViewModel: SmartNotificationAlarmViewModel
    @State private var toast: Toast?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("배터리")
                        .customNormalTextFont(fontSize: FontSizeType.medium.size, isBold: true)
                        .padding(10)
                    
                    Picker("CPU 과사용시 종료하기", selection: $smartNotificationAlarmViewModel.selectedOption) {
                        ForEach(BatteryExitOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("배터리 상태 (0-100%)")
                            WTextField(text: $smartNotificationAlarmViewModel.batteryPercentage)
                                .padding(5)
                        }
                        
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                    }
                    
                    Toggle(isOn: $smartNotificationAlarmViewModel.isBattryCurrentMessageMode) {
                        Text("배터리 상태 설정된 값이 완료됐을 시 알람 울리기")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    .padding()
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Toggle(isOn: $smartNotificationAlarmViewModel.isBatteryWarningMode) {
                        Text("배터리 충전 안될 시 알람 울리기")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    .padding()
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.horizontal, 20)
            }
            HStack {
                Spacer()
                Button(action: {
                    smartNotificationAlarmViewModel.saveConfig()
                    toast = Toast(type: .info, title: "정보", message: "저장이 완료되었습니다.", duration: 3)
                }) {
                    Text("확인")
                        .padding()
                        .cornerRadius(10)
                }
            }
            .padding(.trailing, 20)
            .padding(.top, 10)
        }
        .onAppear {
            smartNotificationAlarmViewModel.loadConfig()
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .navigationTitle(CategoryType.smartNotificationAlarm.title)
        .preferredColorScheme(colorSchemeViewModel.colorScheme == ColorSchemeMode.Dark.title ? .dark : .light)
        .toastView(toast: $toast)
    }
}
