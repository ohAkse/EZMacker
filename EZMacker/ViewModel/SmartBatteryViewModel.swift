//
//  SmartBatteryViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//
import Combine
import SwiftUI

class SmartBatteryViewModel<ProvidableType: AppSmartBatteryRegistryProvidable>: ObservableObject {
    deinit {
        Logger.writeLog(.debug, message: "SmartBatteryViewModel deinit Called")
    }
    // UI 정보
    @Published var batteryConditionData: BatteryConditionData = .init()
    @Published var batteryMatricsData: BatteryMetricsData = .init()
    @Published var adapterMetricsData: AdapterMetricsData = .init()
    
    // 옵션 설정에 따른 표시 설정 관련 변수
    private var isSentBatteryCapacityAlarmMode = false
    private var isSentBatteryChargingErorAlarmMode = false
    
    // 일반 설정값들
    private var appSmartBatteryService: ProvidableType
    private var systemPreferenceService: SystemPreferenceAccessible
    private var appSettingService: AppSmartSettingProvidable
    private var appProcessService: AppSmartProcessProvidable
    private var appChargingErrorCount = 0
    private var timer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    init(appSmartBatteryService: ProvidableType, appSettingService: AppSmartSettingProvidable, appProcessService: AppSmartProcessProvidable, systemPreferenceService: SystemPreferenceAccessible) {
        self.appSmartBatteryService = appSmartBatteryService
        self.appSettingService = appSettingService
        self.appProcessService = appProcessService
        self.systemPreferenceService =  systemPreferenceService
    }
}
extension SmartBatteryViewModel {
    func startAdapterConnectionTimer() {
        timer = Timer.publish(every: 1.5, on: RunLoop.main, in: .default)
            .autoconnect()
            .prepend(Date())
            .sink { [weak self] _ in
                self?.fetchBatteryCommonMetrics()
            }
        timer?.store(in: &cancellables)
    }
    func stopAdapterConnectionTimer() {
        timer?.cancel()
        timer = nil
        cancellables.removeAll()
    }
    // 배터리 충전과 상관없이 연결정보(충전 데이터, 남은시간/예상완충시간 등)
    func fetchBatteryCommonMetrics() {
        checkSettingConfig()
        validateAdapterConnection()
        appSmartBatteryService.getRegistry(forKey: .ChargerData)
            .subscribe(on: DispatchQueue.global())
            .compactMap { $0 as? [String: Any] }
            .compactMap { dict -> ChargeData? in
                guard let vacVoltageLimit = dict["VacVoltageLimit"] as? Int,
                      let chargingCurrent = dict["ChargingCurrent"] as? CGFloat,
                      let timeChargingThermallyLimited = dict["TimeChargingThermallyLimited"] as? Int,
                      let chargerStatus = dict["ChargerStatus"] as? Data,
                      let chargingVoltage = dict["ChargingVoltage"] as? CGFloat,
                      let chargerInhibitReason = dict["ChargerInhibitReason"] as? Int,
                      let chargerID = dict["ChargerID"] as? Int,
                      let notChargingReason = dict["NotChargingReason"] as? Int else {
                    return nil
                }
                return ChargeData(vacVoltageLimit: vacVoltageLimit,
                                  chargingCurrent: chargingCurrent,
                                  timeChargingThermallyLimited: timeChargingThermallyLimited,
                                  chargerStatus: chargerStatus,
                                  chargingVoltage: chargingVoltage,
                                  chargerInhibitReason: chargerInhibitReason,
                                  chargerID: chargerID,
                                  notChargingReason: notChargingReason)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] charge in
                guard let self = self else { return }
                if batteryMatricsData.chargeData.count > 5 {
                    batteryMatricsData.chargeData.removeAll()
                }
                batteryMatricsData.chargeData.append(charge)
                appChargingErrorCount += 1
            }
            .store(in: &cancellables)
        Publishers.CombineLatest(
            appSmartBatteryService.getRegistry(forKey: .TimeRemaining).compactMap { $0 as? Int },
            appSmartBatteryService.getPowerSourceValue(for: .chargingTime, defaultValue: 0)
        )
        .sink { [weak self] remainingTime, chargingTime in
            guard let self = self else { return }
            batteryMatricsData.remainingTime = remainingTime
            batteryMatricsData.chargingTime = chargingTime
        }
        .store(in: &cancellables)
        appSmartBatteryService.getRegistry(forKey: .CurrentCapacity)
            .subscribe(on: DispatchQueue.global())
            .compactMap { $0 as? Int }
            .map { Double($0) / 100.0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentCapacity in
                guard let self = self else { return }
                batteryMatricsData.currentBatteryCapacity = currentCapacity
                
            }
            .store(in: &cancellables)
    }
    // 하단
    func fetchBatteryBasicSpec() {
        Publishers.CombineLatest4(
            appSmartBatteryService.getRegistry(forKey: .CycleCount).compactMap { $0 as? Int },
            appSmartBatteryService.getRegistry(forKey: .Temperature).compactMap { $0 as? Int },
            appSmartBatteryService.getRegistry(forKey: .DesignCapacity).compactMap { $0 as? Int },
            appSmartBatteryService.getRegistry(forKey: .AppleRawMaxCapacity).compactMap { $0 as? Int }
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] cycleCount, temperature, designedCapacity, batteryMaxCapacity in
            guard let self = self else { return }
            batteryConditionData.cycleCount = cycleCount
            batteryConditionData.temperature = temperature
            batteryConditionData.designedCapacity = designedCapacity
            batteryConditionData.batteryMaxCapacity = batteryMaxCapacity
        }
        .store(in: &cancellables)
    }
    func validateAdapterConnection() {
        appSmartBatteryService.getRegistry(forKey: .AppleRawAdapterDetails)
            .subscribe(on: DispatchQueue.global())
            .tryMap { value -> [AdapterData] in
                guard let value = value else { throw AdapterConnect.dataNotFound }
                let data = try JSONSerialization.data(withJSONObject: value, options: [])
                return try JSONDecoder().decode([AdapterData].self, from: data)
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] result in
                    if case .failure = result {
                        self?.adapterMetricsData.adapterConnectionSuccess = .decodingFailed
                    }
                },
                receiveValue: { [weak self] adapterDetails in
                    self?.validateAdapterData(adapterDetails)
                }
            )
            .store(in: &cancellables)
    }
    
    private func validateAdapterData(_ adapterDetails: [AdapterData]) {
        let adapterConnected = !adapterDetails.isEmpty
        if adapterMetricsData.isAdapterConnected != adapterConnected {
            adapterMetricsData.isAdapterConnected.toggle()
        }
        if adapterConnected {
            adapterMetricsData.adapterData = adapterDetails
            adapterMetricsData.adapterConnectionSuccess = .processing
        } else {
            fetchBatteryBasicExtraSpec()
        }
    }
    
    private func fetchBatteryBasicExtraSpec() {
        Publishers.CombineLatest(
            appSmartBatteryService.getPowerSourceValue(for: .batteryHealth, defaultValue: ""),
            appSmartBatteryService.getRegistry(forKey: .BatteryCellDisconnectCount).compactMap { $0 as? Int }
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] healthState, batteryCellDisconnectCount in
            self?.batteryConditionData.healthState = healthState
            self?.batteryConditionData.batteryCellDisconnectCount = batteryCellDisconnectCount
        }
        .store(in: &cancellables)
    }
}
// MARK: 환경설정값에 따른 외부 세팅
extension SmartBatteryViewModel {
    func checkSettingConfig() {
        if let isBatteryWarningMode: Bool = appSettingService.loadConfig(.isBatteryWarningMode) {
            if isBatteryWarningMode {
                if let lastChargeData = batteryMatricsData.chargeData.last, lastChargeData.notChargingReason != 0,
                   appChargingErrorCount >= 6  && !isSentBatteryChargingErorAlarmMode {
                    AppNotificationManager.shared.sendNotification(title: "배터리 오류 발생", subtitle: "errorCode: \(lastChargeData.notChargingReason)")
                    isSentBatteryChargingErorAlarmMode = true
                }
            }
        }
        if let isBattryCurrentMessageMode: Bool = appSettingService.loadConfig(.isBattryCurrentMessageMode) {
            if isBattryCurrentMessageMode {
                if let batteryPercentage: String = appSettingService.loadConfig(.batteryPercentage) {
                    let batteryDobulePercentage = (Double(batteryPercentage) ?? 0) / 100
                    if batteryDobulePercentage <= batteryMatricsData.currentBatteryCapacity {
                        if !isSentBatteryCapacityAlarmMode {
                            AppNotificationManager.shared.sendNotification(title: "충전 안내", subtitle: "설정하신 배터리 충전이 완료되었습니다.")
                        }
                        isSentBatteryCapacityAlarmMode = true
                    }
                }
            }
        }
        
        if let selectedExitOption: String = appSettingService.loadConfig(.appExitMode) {
            if selectedExitOption != "사용안함" {
                if let batteryLevel = Int.extractNumericPart(from: selectedExitOption) {
                    if Int(appProcessService.getTotalPercenatage()) > batteryLevel {
                        AppNotificationManager.shared.sendNotification(title: "종료 안내", subtitle: "CPU가 높아 앱을 종료합니다.")
                        NSApplication.shared.terminate(nil)
                    }
                }
            }
        }
    }
    func openSettingWindow(settingPath: String) {
        systemPreferenceService.openSystemPreferences(systemPath: settingPath)
    }
}
