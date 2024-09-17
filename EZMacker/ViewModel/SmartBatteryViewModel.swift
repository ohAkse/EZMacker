//
//  SmartBatteryViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import Combine
import SwiftUI
import EZMackerUtilLib
import EZMackerServiceLib
import SwiftData
class SmartBatteryViewModel<ProvidableType: AppSmartBatteryRegistryProvidable>: ObservableObject {
    deinit {
        Logger.writeLog(.debug, message: "SmartBatteryViewModel deinit Called")
    }
    // MARK: - Published Variable
    @Published var batteryConditionData: BatteryConditionData = .init()
    @Published var batteryMatricsData: BatteryMetricsData = .init()
    @Published var adapterMetricsData: AdapterMetricsData = .init()
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var subtitle = ""
    // MARK: - Service Variable
    private let appSmartBatteryService: ProvidableType
    private let systemPreferenceService: SystemPreferenceAccessible
    private let appSettingService: AppSettingProvidable
    private let appProcessService: AppSmartProcessProvidable
    // MARK: - Flag Variables
    private(set) var isBatteryCapacityAlarmMode = false
    private(set) var isBatteryChargingErrorAlarmMode = false
    private(set) var isOverFullcpuUsageExitMode = false
    private(set) var isSentChargingErrorAlarm = false
    private(set) var isSentCapacityAlarm = false
    private(set) var hasShownAlert = false
    // MARK: - Normal Variables
    private(set) var appChargingErrorCount = 0
    private(set) var adapterDecodingErrorCount = 0
    private(set) var timer: AnyCancellable?
    private(set) var cancellables = Set<AnyCancellable>()
    private(set) var modelContext: ModelContext?
    
    init(appSmartBatteryService: ProvidableType, appSettingService: AppSettingProvidable, appProcessService: AppSmartProcessProvidable, systemPreferenceService: SystemPreferenceAccessible) {
        self.appSmartBatteryService = appSmartBatteryService
        self.appSettingService = appSettingService
        self.appProcessService = appProcessService
        self.systemPreferenceService = systemPreferenceService
        
        checkSettingConfig()
        fetchBatteryBasicExtraSpec()
        fetchBatteryBasicSpec()
    }
}
extension SmartBatteryViewModel {
    func startAdapterConnectionTimer() {
        timer = Timer.publish(every: 1.5, on: RunLoop.main, in: .default)
            .autoconnect()
            .prepend(Date())
            .sink { [weak self] _ in
                self?.fetchBatteryCommonMetrics()
                if self!.isOverFullcpuUsageExitMode {
                    self?.appProcessService.checkProcessUpdateInfo()
                    self?.needToAppExit()
                }
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
                if charge.notChargingReason != 0 {
                    appChargingErrorCount += 1
                    needToChargingErrorAlarm(errorCode: charge.notChargingReason)
                }
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
                needToBatteryCapacityAlarm()
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
                    guard let self = self else { return }
                    if case .failure = result {
                        adapterDecodingErrorCount += 1
                        switch adapterDecodingErrorCount {
                        case 1...5:
                            adapterMetricsData.adapterConnectionSuccess = .decodingFailed
                        case 6...10:
                            adapterMetricsData.adapterConnectionSuccess = .dataNotFound
                            if !hasShownAlert {
                                showAlert = true
                                hasShownAlert = true
                                subtitle = "에러"
                                alertMessage = adapterMetricsData.adapterConnectionSuccess.localizedDescription
                            }
                        case 11...:
                            adapterMetricsData.adapterConnectionSuccess = .processing // 한번 에러 띄우면 그냥 종료까지 계산으로 넘기기위해 프로세싱으로
                        default:
                            break // 이 경우는 발생하지 않지만, switch 문의 완전성을 위해 포함
                        }
                    }
                },
                receiveValue: { [weak self] adapterDetails in
                    self?.validateAdapterData(adapterDetails)
                    self?.hasShownAlert = false // 충전기를 다시 꽃으면 초기화
                    self?.adapterDecodingErrorCount = 0
                }
            )
            .store(in: &cancellables)
    }
    
    private func validateAdapterData(_ adapterDetails: [AdapterData]) {
        let adapterConnected = !adapterDetails.isEmpty
        if adapterConnected {
            adapterMetricsData.adapterData = adapterDetails
            adapterMetricsData.adapterConnectionSuccess = .processing
        } else {
            fetchBatteryBasicExtraSpec()
        }
        if adapterMetricsData.isAdapterConnected != adapterConnected {
            adapterMetricsData.isAdapterConnected.toggle()
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
        if let isBatteryWarningMode: Bool = appSettingService.loadConfig(.isBatteryChargingErrorMode) {
            if isBatteryWarningMode {
                isBatteryChargingErrorAlarmMode = true
            }
        }
        if let isBattryCurrentMessageMode: Bool = appSettingService.loadConfig(.isBatteryCurrentMessageMode) {
            if isBattryCurrentMessageMode {
                isBatteryCapacityAlarmMode = true
            }
        }
        
        if let selectedExitOption: String = appSettingService.loadConfig(.cpuUsageExitType) {
            if selectedExitOption != CPUUsageExitType.unused.typeName {
                isOverFullcpuUsageExitMode = true
            }
        }
    }
    func needToChargingErrorAlarm(errorCode: Int) {
        if isBatteryChargingErrorAlarmMode && !isSentChargingErrorAlarm {
            if appChargingErrorCount >= 6 {
                AppNotificationManager.shared.sendNotification(title: "배터리 오류 발생", subtitle: "errorCode: \(errorCode)")
                isSentChargingErrorAlarm = true
            }
        }
    }
    func needToBatteryCapacityAlarm() {
        if isBatteryCapacityAlarmMode && !isSentCapacityAlarm {
            if let batteryPercentage: String = appSettingService.loadConfig(.batteryPercentage) {
                let batteryDobulePercentage = (Double(batteryPercentage) ?? 0) / 100
                if batteryDobulePercentage <= batteryMatricsData.currentBatteryCapacity {
                    AppNotificationManager.shared.sendNotification(title: "충전 안내", subtitle: "설정하신 배터리 충전이 완료되었습니다.")
                    isSentCapacityAlarm = true
                }
            }
        }
    }
    func needToAppExit() {
        if let selectedExitOption: String = appSettingService.loadConfig(.cpuUsageExitType) {
            if selectedExitOption != CPUUsageExitType.unused.typeName {
                if let cpuUsage = Int.extractNumericPart(from: selectedExitOption) {
                    Logger.writeLog(.debug, message: String(appProcessService.getTotalPercenatage()))
                    if Int(appProcessService.getTotalPercenatage()) > cpuUsage {
                        NSApplication.shared.terminate(nil)
                    }
                }
                isOverFullcpuUsageExitMode = true
            }
        }
    }
    
    func openSettingWindow(settingPath: String) {
        systemPreferenceService.openSystemPreferences(systemPath: settingPath)
    }
}
