//
//  SmartBatteryView.swift
//  EZMacker
//
//  Created by 박유경 on 8/31/24.
//

import SwiftUI
import EZMackerUtilLib
import EZMackerServiceLib

struct SmartBatteryView<ProvidableType>: View where ProvidableType: AppSmartBatteryRegistryProvidable {
    @StateObject private var smartBatteryViewModel: SmartBatteryViewModel<AppSmartBatteryService>
    @State private(set) var toast: ToastData?
    @State private(set) var isAdapterAnimated = false
    @State private(set) var hasShownToast = false
    @State private(set) var errCount = 0
    
    init(factory: ViewModelFactory) {
        _smartBatteryViewModel = StateObject(wrappedValue: factory.createSmartBatteryViewModel())
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Spacer(minLength: 20)
                topSection(geo: geo)
                Spacer(minLength: 40)
                adapterInfoSection(geo: geo)
                Spacer(minLength: 30)
                EZBatteryBarView(batteryLevel: $smartBatteryViewModel.batteryMatricsData.currentBatteryCapacity, isAdapterConnected: $smartBatteryViewModel.adapterMetricsData.isAdapterConnected)
                Spacer(minLength: 15)
                bottomInfoSection(geo: geo)
                    .offset(y: 15)
            }
            .onAppear {
                smartBatteryViewModel.validateAdapterConnection()
                smartBatteryViewModel.startAdapterConnectionTimer()
            }
            
            .onDisappear {
                smartBatteryViewModel.stopAdapterConnectionTimer()
            }
            .navigationTitle(CategoryType.smartBattery.title)
            .toastView(toast: $toast)
            .sheet(isPresented: $smartBatteryViewModel.showAlert) {
                AlertOKCancleView(
                    isPresented: $smartBatteryViewModel.showAlert,
                    title: "에러",
                    subtitle: "확인 불가",
                    content: smartBatteryViewModel.alertMessage
                )
            }
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
            if smartBatteryViewModel.adapterMetricsData.isAdapterConnected {
                if smartBatteryViewModel.batteryMatricsData.currentBatteryCapacity * 100 >= 100 {
                    EZBatteryInfoView(imageName: getBatteryImageName(), isSystem: false, title: "완충까지", info: "충전완료")
                } else {
                    EZBatteryInfoView(imageName: getBatteryImageName(), isSystem: false, title: "완충까지", info: smartBatteryViewModel.batteryMatricsData.chargingTime.toHourMinute())
                }
            } else {
#if !IMPORVE_LATER // 충전기를 꽃을 시 잠시 ioreg에서 남은시간/완충시간 계산이 튀는 문제가 있어 어떻게 처리할지 고민할것
                EZBatteryInfoView(imageName: getBatteryImageName(), isSystem: false, title: "종료까지", info: smartBatteryViewModel.batteryMatricsData.remainingTime.toHourMinute())
#else
                if smartBatteryViewModel.adapterMetricsData.adapterConnectionSuccess == .decodingFailed {
                    EZLoadingView(size: 120, text: "수집중..")
                } else {
                    if smartBatteryViewModel.batteryMatricsData.chargingTime == -1 &&  smartBatteryViewModel.adapterMetricsData.adapterConnectionSuccess == .dataNotFound {
                        EZBatteryInfoView(imageName: getBatteryImageName(), isSystem: false, title: "예측불가", info: "-분")
                    } else {
                        EZBatteryInfoView(imageName: getBatteryImageName(), isSystem: false, title: "종료까지", info: smartBatteryViewModel.batteryMatricsData.remainingTime.toHourMinute())
                    }
                }
#endif
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
                .padding(.vertical, 20)
                .padding(.trailing, 10)
                EZBatteryMonitoringView(chargeData: $smartBatteryViewModel.batteryMatricsData.chargeData, isAdapterConnect: $smartBatteryViewModel.adapterMetricsData.isAdapterConnected)
                    .padding(.vertical, 20)
                    .onReceive(smartBatteryViewModel.$batteryMatricsData) { metricsData in
                        checkAndShowFullyChargedWarning(metricsData: metricsData)
                    }
            }
            
            Button(
                action: {
                    smartBatteryViewModel.openSettingWindow(settingPath: SystemPreference.batterySave.pathString)
                },
                label: {}
            )
            .ezButtonImageStyle(
                imageName: "gearshape.fill",
                imageSize: CGSize(width: 20, height: 20),
                lightModeBackgroundColor: .clear,
                darkModeBackgroundColor: .clear
            )
            .offset(x: 5, y: -15)
        }
        .frame(width: geo.size.width * 0.75, height: geo.size.height * 0.25)
    }
    
    private func checkAndShowFullyChargedWarning(metricsData: BatteryMetricsData) {
        guard let lastChargeData = metricsData.chargeData.last else { return }
        
        let chargeErrorType = BatteryChargeErrorType.from(hexString: lastChargeData.notChargingReason.toHexaString())
        
        if !hasShownToast {
            if chargeErrorType.isFullyCharged() {
                toast = ToastData(type: .warning,
                                  message: "배터리가 충전 대기 중입니다. 충전을 원할 시 어댑터를 다시 꽂거나 상단 메뉴의 배터리 탭에서'지금 완전 충전'을 눌러 충전을 재개하세요.")
            } else {
                toast = ToastData(type: .info,
                                  message: "배터리 종료/충전 시간은 시스템 구성에 따라 최대 약 3분정도 시간이 소요됩니다.")
            }
            hasShownToast = true
        }
        
    }
    
    private func adapterInfoSection(geo: GeometryProxy) -> some View {
        VStack {
            if smartBatteryViewModel.adapterMetricsData.isAdapterConnected {
                if smartBatteryViewModel.adapterMetricsData.adapterConnectionSuccess == .dataNotFound {
                    disconnectedAdapterInfo(geo: geo)
                } else {
                    connectedAdapterInfo(geo: geo)
                }
            } else {
                disconnectedAdapterInfo(geo: geo)
            }
        }
        .frame(height: geo.size.height * 0.4)
        .animation(.spring(), value: smartBatteryViewModel.adapterMetricsData.isAdapterConnected)
    }
    
    private func connectedAdapterInfo(geo: GeometryProxy) -> some View {
        HStack {
            if let adapterInfo = smartBatteryViewModel.adapterMetricsData.adapterData.first {
                VStack {
                    EZImageView(systemName: "battery_adapter", isSystemName: false)
                    EZContentView(content: adapterInfo.Name)
                }
                .frame(width: geo.size.width * 0.3)
                VStack(spacing: 0) {
                    Spacer()
                    EZBatteryAdapterView(title: "Adp ID", content: "\(adapterInfo.AdapterID)")
                    Spacer()
                    EZBatteryAdapterView(title: "Model ID", content: adapterInfo.Model)
                    Spacer()
                    EZBatteryAdapterView(title: "F/W Ver", content: adapterInfo.FwVersion)
                    Spacer()
                }
                .ezBackgroundColorStyle()
                .frame(width: geo.size.width * 0.33)
                
                Spacer(minLength: 5)
                
                VStack(spacing: 0) {
                    Spacer()
                    EZBatteryAdapterView(title: "Mfr.", content: adapterInfo.Manufacturer)
                    Spacer()
                    EZBatteryAdapterView(title: "Watts", content: "\(adapterInfo.Watts)W")
                    Spacer()
                    EZBatteryAdapterView(title: "H/W Ver", content: adapterInfo.HwVersion)
                    Spacer()
                }
                .frame(width: geo.size.width * 0.33)
                .ezBackgroundColorStyle()
            } else {
                Text("No adapter connected")
                    .frame(maxWidth: .infinity)
            }
        }
    }
    private func disconnectedAdapterInfo(geo: GeometryProxy) -> some View {
        Group {
            if smartBatteryViewModel.adapterMetricsData.adapterConnectionSuccess == .decodingFailed {
                HStack(alignment: .center, spacing: 0) {
                    HStack(alignment: .center, spacing: 0) {
                        EZLoadingView(size: 180, text: "어댑터 정보 수집중..")
                            .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.4)
                    }
                    
                    Text("연결 상태 및 하드웨어 세부사항 확인 중입니다.")
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
                        EZBatteryInfoView(imageName: "battery_status",
                                          isSystem: false,
                                          title: "배터리 상태",
                                          info: smartBatteryViewModel.batteryConditionData.healthState,
                                          isBatterStatus: true)
                        .frame(height: geo.size.height * 0.2)
                        EZBatteryInfoView(imageName: "battery_cell", isSystem: false, title: "베터리셀 끊김 횟수", info: "\(smartBatteryViewModel.batteryConditionData.batteryCellDisconnectCount)")
                            .frame(height: geo.size.height * 0.2)
                        
                    }
                }
            }
        }
    }
    
    private func bottomInfoSection(geo: GeometryProxy) -> some View {
        HStack(spacing: 30) {
            EZBatteryInfoView(imageName: "battery_recycle", isSystem: false, title: "사이클 수", info: smartBatteryViewModel.batteryConditionData.cycleCount.toBun())
                .frame(height: geo.size.height * 0.2)
            EZBatteryInfoView(imageName: "battery_thermometer", isSystem: false, title: "온도", info: smartBatteryViewModel.batteryConditionData.temperature.toDegree())
                .frame(height: geo.size.height * 0.2)
            EZBatteryInfoView(imageName: "battery_currentCapa", isSystem: false, title: "현재 용량", info: smartBatteryViewModel.batteryConditionData.batteryMaxCapacity.tomAH())
                .frame(height: geo.size.height * 0.2)
            EZBatteryInfoView(imageName: "battery_designdCapa", isSystem: false, title: "설계 용량", info: smartBatteryViewModel.batteryConditionData.designedCapacity.tomAH())
                .frame(height: geo.size.height * 0.2)
        }
    }
}

extension SmartBatteryView {
    private func getBatteryImageName() -> String {
        if smartBatteryViewModel.adapterMetricsData.isAdapterConnected {
            if smartBatteryViewModel.batteryMatricsData.currentBatteryCapacity == 1 {
                return "battery_full_charge"
            } else {
                return "battery_charging"
            }
        } else {
            switch smartBatteryViewModel.batteryMatricsData.currentBatteryCapacity {
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
