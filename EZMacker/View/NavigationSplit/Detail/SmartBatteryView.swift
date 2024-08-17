import SwiftUI

struct SmartBatteryView<ProvidableType>: View where ProvidableType: AppSmartBatteryRegistryProvidable {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    @StateObject var smartBatteryViewModel: SmartBatteryViewModel<ProvidableType>
    @State private var toast: ToastData?
    @State private var isAdapterAnimated = false
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Spacer(minLength: 20)
                topSection(geo: geo)
                Spacer(minLength: 40)
                adapterInfoSection(geo: geo)
                Spacer(minLength: 30)
                EZBatteryBarView(batteryLevel: $smartBatteryViewModel.currentBatteryCapacity, isAdapterConnected: $smartBatteryViewModel.isAdapterConnected)
                Spacer(minLength: 15)
                bottomInfoSection(geo: geo)
                    .offset(y: 15)
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
            Spacer(minLength: 0)
            voltageInfoView(geo: geo)
        }
        .frame(height: geo.size.height * 0.2)
    }
    private func chargingInfoView(geo: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if smartBatteryViewModel.isAdapterConnected {
                if smartBatteryViewModel.currentBatteryCapacity * 100 == 100 {
                    EZRectangleHImageTextView(imageName: getBatteryImageName(), isSystem: false, title: "완충까지", info: "충전완료")
                        
                } else {
                    EZRectangleHImageTextView(imageName: getBatteryImageName(), isSystem: false, title: "완충까지", info: smartBatteryViewModel.chargingTime.toHourMinute())
                }
            } else if smartBatteryViewModel.chargingTime <= 1 {
                EZRectangleHImageTextView(imageName: getBatteryImageName(), isSystem: false, title: "종료까지", info: smartBatteryViewModel.remainingTime.toHourMinute())
            }
        }
        .onReceive(smartBatteryViewModel.$isAdapterConnected) { isConnected in
            if isConnected {
                toast = ToastData(type: .info, title: "정보", message: "배터리 종료/충전 시간은 시스템 구성에 따라 최대 약 3분정도 시간이 소요됩니다.", duration: 10)
            }
        }
        .frame(width: geo.size.width * 0.22, height: geo.size.height * 0.25)
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
                
                EZGridHMonitoringView(chargeData: $smartBatteryViewModel.chargeData, isAdapterConnect: $smartBatteryViewModel.isAdapterConnected)
                    .padding(.vertical,20)
            }
            Button(action: {  smartBatteryViewModel.openSettingWindow(settingPath: SystemPreference.batterySave.pathString) }) {}
                .ezButtonImageStyle(
                    imageName: "gearshape.fill",
                    imageSize: CGSize(width: 20, height: 20),
                    lightModeBackgroundColor: .clear,
                    darkModeBackgroundColor:  .clear
                )
                .offset(x: 5, y: -15)
        }
        .frame(width: geo.size.width * 0.75, height: geo.size.height * 0.25)
    }
    
    private func adapterInfoSection(geo: GeometryProxy) -> some View {
        VStack {
            if smartBatteryViewModel.isAdapterConnected {
                connectedAdapterInfo(geo: geo)
            } else {
                disconnectedAdapterInfo(geo: geo)
            }
        }
        .frame(height: geo.size.height * 0.4)
        .animation(.spring(), value: smartBatteryViewModel.isAdapterConnected)
    }
    
    private func connectedAdapterInfo(geo: GeometryProxy) -> some View {
        HStack {
            if let adapterInfo = smartBatteryViewModel.adapterInfo?.first {
                VStack {
                    EZImage(systemName: "battery_adapter", isSystemName: false)
                    EZContent(content: adapterInfo.Name)
                }
                .frame(width: geo.size.width * 0.3)
                VStack(spacing: 0) {
                    Spacer()
                    EZElipseHImageView(title: "Adp ID", content: "\(adapterInfo.AdapterID)")
                    Spacer()
                    EZElipseHImageView(title: "Model ID", content: "\(adapterInfo.Model)")
                    Spacer()
                    EZElipseHImageView(title: "F/W Ver", content: "\(adapterInfo.FwVersion)")
                    Spacer()
                }
                .ezBackgroundColorStyle()
                .frame(width: geo.size.width * 0.33)
                
                Spacer(minLength: 5)
                
                VStack(spacing: 0) {
                    Spacer()
                    EZElipseHImageView(title: "Mfr.", content: "\(adapterInfo.Manufacturer)")
                    Spacer()
                    EZElipseHImageView(title: "Watts", content: "\(adapterInfo.Watts)" + "W")
                    Spacer()
                    EZElipseHImageView(title: "H/W Ver", content: "\(adapterInfo.HwVersion)")
                    Spacer()
                }
                .frame(width: geo.size.width * 0.33)
                .ezBackgroundColorStyle()
            }
        }
    }
    
    private func disconnectedAdapterInfo(geo: GeometryProxy) -> some View {
        Group {
            if smartBatteryViewModel.adapterConnectionSuccess == .decodingFailed {
                HStack(alignment: .center, spacing: 0) {
                    HStack(alignment: .center, spacing: 0) {
                            ProgressView("")
                            .scaleEffect(2.0)
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.4)
                    }
                    
                    Text("정보를 수집중입니다. 잠시만 기다려 주세요.")
                        .ezNormalTextStyle(fontSize: FontSizeType.large.size, isBold: true)
                        .padding(.leading, 10)
                }
            } else {
                HStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .center) {
                        GifRepresentableView(gifName: "battery_connect_animation", imageSize: CGSize(width: 50, height: 40))
                    }
                    .frame(width: geo.size.width * 0.5)
                    VStack(spacing: 0) {
                        EZRectangleHImageTextView(imageName: "battery_status",
                                                  isSystem: false,
                                                  title: "배터리 상태",
                                                  info: smartBatteryViewModel.healthState == "" ? "계산중.." : smartBatteryViewModel.healthState,
                                                  isBatterStatus: true)
                            .frame(height: geo.size.height * 0.2)
                        EZRectangleHImageTextView(imageName: "battery_cell", isSystem: false, title: "베터리셀 끊김 횟수", info: "\(smartBatteryViewModel.batteryCellDisconnectCount)")
                            .frame(height: geo.size.height * 0.2)

                    }
                }
            }
        }
    }
    
    private func bottomInfoSection(geo: GeometryProxy) -> some View {
        HStack(spacing: 30) {
            EZRectangleHImageTextView(imageName: "battery_recycle", isSystem: false, title: "사이클 수", info: smartBatteryViewModel.cycleCount.toBun())
                .frame(height: geo.size.height * 0.2)
            EZRectangleHImageTextView(imageName: "battery_thermometer", isSystem: false, title: "온도", info: smartBatteryViewModel.temperature.toDegree())
                .frame(height: geo.size.height * 0.2)
            EZRectangleHImageTextView(imageName: "battery_currentCapa", isSystem: false, title: "배터리 용량", info: smartBatteryViewModel.batteryMaxCapacity.tomAH())
                .frame(height: geo.size.height * 0.2)
            EZRectangleHImageTextView(imageName: "battery_designdCapa", isSystem: false, title: "설계 용량", info: smartBatteryViewModel.designedCapacity.tomAH())
                .frame(height: geo.size.height * 0.2)
        }
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


