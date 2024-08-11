import SwiftUI

struct SmartBatteryView<ProvidableType>: View where ProvidableType: AppSmartBatteryRegistryProvidable {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    @StateObject var smartBatteryViewModel: SmartBatteryViewModel<ProvidableType>
    @State private var toast: Toast?
    @State private var isAdapterAnimated = false
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 10) {
                topSection(geo: geo)
                adapterInfoSection(geo: geo)
                InfoBatteryBarView(batteryLevel: $smartBatteryViewModel.currentBatteryCapacity, isAdapterConnected: $smartBatteryViewModel.isAdapterConnected)
                    .frame(height: 50)
                    .padding(.top, 10)
                bottomInfoSection(geo: geo)
            }
            .onAppear {
                smartBatteryViewModel.requestStaticBatteryInfo()
                smartBatteryViewModel.startConnectTimer()
                smartBatteryViewModel.checkAdapterConnectionStatus()
            }
            .onDisappear {
                smartBatteryViewModel.stopConnectTimer()
            }
            .navigationTitle(CategoryType.smartBattery.title)
            .toastView(toast: $toast)
        }
        .padding(30)
    }
    
    private func topSection(geo: GeometryProxy) -> some View {
        HStack(alignment: .top, spacing: 0) {
            chargingInfoView(geo: geo)
            Spacer()
            voltageInfoView(geo: geo)
        }
        .frame(height: geo.size.height * 0.2)
    }
    private func chargingInfoView(geo: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if smartBatteryViewModel.isAdapterConnected {
                if smartBatteryViewModel.currentBatteryCapacity * 100 == 100 {
                    InfoRectangleHImageTextView(imageName: getBatteryImageName(), isSystem: false, title: "완충까지", info: "충전완료")
                        .environmentObject(colorSchemeViewModel)
                } else {
                    InfoRectangleHImageTextView(imageName: getBatteryImageName(), isSystem: false, title: "완충까지 ", info: smartBatteryViewModel.chargingTime.toHourMinute())
                        .environmentObject(colorSchemeViewModel)
                }
            } else if smartBatteryViewModel.chargingTime <= 1 {
                InfoRectangleHImageTextView(imageName: getBatteryImageName(), isSystem: false, title: "종료까지 ", info: smartBatteryViewModel.remainingTime.toHourMinute())
                    .environmentObject(colorSchemeViewModel)
            }
        }
        .onReceive(smartBatteryViewModel.$isAdapterConnected) { isConnected in
            if isConnected {
                toast = Toast(type: .info, title: "정보", message: "배터리 종료/충전 시간은 시스템 구성에 따라 최대 5분이 소요됩니다.", duration: 10)
            }
        }
        .frame(width: geo.size.width * 0.2, height: geo.size.height * 0.2)
    }
    
    private func voltageInfoView(geo: GeometryProxy) -> some View {
        ZStack(alignment: .topTrailing) {
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .trailing) {
                    Text("Max V")
                        .lineLimit(1)
                        .fixedSize()
                    Spacer()
                    Text("Min V")
                        .lineLimit(1)
                        .fixedSize()
                }
                .padding(.vertical,20)
                .padding(.trailing, 10)
                
                InfoGridHMonitoringView(chargeData: $smartBatteryViewModel.chargeData, isAdapterConnect: $smartBatteryViewModel.isAdapterConnected)
                    .padding(.vertical,20)
            }
            
            Image("battery_setting")
                .resizable()
                .frame(width: 25, height: 25)
                .background(Color.clear)
                .onTapGesture {
                    smartBatteryViewModel.openSettingWindow(settingPath: SystemPreference.batterySave.pathString)
                }
                .offset(y: -20)
        }
        .frame(width: geo.size.width * 0.72, height: geo.size.height * 0.2)
    }
    
    private func adapterInfoSection(geo: GeometryProxy) -> some View {
        VStack {
            if smartBatteryViewModel.isAdapterConnected {
                connectedAdapterInfo(geo: geo)
            } else {
                disconnectedAdapterInfo(geo: geo)
            }
        }
        .frame(height: geo.size.height * 0.45)
        .animation(.spring(), value: smartBatteryViewModel.isAdapterConnected)
    }
    
    private func connectedAdapterInfo(geo: GeometryProxy) -> some View {
        HStack {
            if let adapterInfo = smartBatteryViewModel.adapterInfo?.first {
                VStack {
                    CustomImage(systemName: "battery_adapter", isSystemName: false)
                    CustomContent(content: adapterInfo.Name)
                }
                
                VStack(spacing: 0) {
                    Spacer()
                    InfoElipseHImageView(title: "어댑터ID", content: "\(adapterInfo.AdapterID)")
                    Spacer()
                    InfoElipseHImageView(title: "모델ID", content: "\(adapterInfo.Model)")
                    Spacer()
                    InfoElipseHImageView(title: "펌웨어버전", content: "\(adapterInfo.FwVersion)")
                    Spacer()
                }
                .background {
                    RoundedRectangle(cornerRadius: 15)
                }
                .frame(width: geo.size.width * 0.4)
                .foregroundColor(ThemeColor.lightGray.color)
                
                Spacer(minLength: 20)
                
                VStack(spacing: 0) {
                    Spacer()
                    InfoElipseHImageView(title: "제조사", content: "\(adapterInfo.Manufacturer)")
                    Spacer()
                    InfoElipseHImageView(title: "와츠", content: "\(adapterInfo.Watts)" + "W")
                    Spacer()
                    InfoElipseHImageView(title: "하드웨어버전", content: "\(adapterInfo.HwVersion)")
                    Spacer()
                }
                .frame(width: geo.size.width * 0.4)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                }
                .foregroundColor(ThemeColor.lightGray.color)
            }
        }
    }
    
    private func disconnectedAdapterInfo(geo: GeometryProxy) -> some View {
        Group {
            if smartBatteryViewModel.adapterConnectionSuccess == .decodingFailed {
                HStack(alignment: .center, spacing: 0) {
                    GifRepresentableView(gifName: "global_loading", imageSize: CGSize(width: geo.size.width * 0.4, height: geo.size.height * 0.4))
                        .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.4)
                    Spacer()
                    Text("정보를 수집중입니다. 잠시만 기다려 주세요.")
                        .customNormalTextFont(fontSize: FontSizeType.large.size, isBold: true)
                    Spacer()
                }
            } else {
                HStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .center) {
                        GifRepresentableView(gifName: "battery_adapter_plugin_animation", imageSize: CGSize(width: 50, height: 50))
                        Spacer(minLength: 10)
                        Text("어댑터를 꽃으면 정보가 나와요!")
                            .customNormalTextFont(fontSize: FontSizeType.large.size, isBold: true)
                            .shadow(radius: 5)
                    }
                    .frame(width: geo.size.width * 0.5)
                    VStack(spacing: 0) {
                        InfoRectangleHImageTextView(imageName: "battery_status", isSystem: false, title: "배터리 상태", info: smartBatteryViewModel.healthState == "" ? "계산중.." : smartBatteryViewModel.healthState)
                            .frame(height: geo.size.height * 0.2)
                            .environmentObject(colorSchemeViewModel)
                        InfoRectangleHImageTextView(imageName: "battery_cell", isSystem: false, title: "베터리셀 끊김 횟수", info: "\(smartBatteryViewModel.batteryCellDisconnectCount)")
                            .frame(height: geo.size.height * 0.2)
                            .environmentObject(colorSchemeViewModel)
                    }
                }
            }
        }
    }
    
    private func bottomInfoSection(geo: GeometryProxy) -> some View {
        HStack(spacing: 30) {
            InfoRectangleHImageTextView(imageName: "battery_recycle", isSystem: false, title: "사이클 수", info: smartBatteryViewModel.cycleCount.toBun())
                .frame(height: geo.size.height * 0.2)
                .environmentObject(colorSchemeViewModel)
            InfoRectangleHImageTextView(imageName: "battery_thermometer", isSystem: false, title: "온도", info: smartBatteryViewModel.temperature.toDegree())
                .frame(height: geo.size.height * 0.2)
                .environmentObject(colorSchemeViewModel)
            InfoRectangleHImageTextView(imageName: "battery_currentCapa", isSystem: false, title: "배터리 용량", info: smartBatteryViewModel.batteryMaxCapacity.tomAH())
                .frame(height: geo.size.height * 0.2)
                .environmentObject(colorSchemeViewModel)
            InfoRectangleHImageTextView(imageName: "battery_designdCapa", isSystem: false, title: "설계 용량", info: smartBatteryViewModel.designedCapacity.tomAH())
                .frame(height: geo.size.height * 0.2)
                .environmentObject(colorSchemeViewModel)
        }
        .padding(.top, 20)
    }
}

extension SmartBatteryView {
    private func getBatteryImageName() -> String {
        if smartBatteryViewModel.isAdapterConnected {
            if smartBatteryViewModel.currentBatteryCapacity == 1 {
                return "battery_full_charge"
            } else {
                return "battery_charging"
            }
        } else {
            switch smartBatteryViewModel.currentBatteryCapacity {
            case 1:
                return "battery_full"
            case 0.67...0.99:
                return "battery_high"
            case 0.34...0.66:
                return "battery_normal"
            case 0...0.33:
                return "battery_low"
            default:
                Logger.fatalErrorMessage("Unknown Battery Level")
            }
        }
        return ""
    }
}
