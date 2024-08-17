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
        stopConnectTimer()
        Logger.writeLog(.debug, message: "SmartBatteryViewModel deinit Called")
    }
    
    //배터리 관련 설정값들
    @Published var isCharging = false
    @Published var temperature = 0
    @Published var currentBatteryCapacity = 0.0
    @Published var remainingTime = 0
    @Published var chargingTime = 0
    @Published var cycleCount = 0
    @Published var maxCapacity = 0
    @Published var healthState = ""
    @Published var batteryMaxCapacity = 0
    @Published var designedCapacity = 0
    @Published var batteryCellDisconnectCount = 0
    @Published var chargeData: [ChargeData] = []
    
    //어댑터 관련 설정값들
    @Published var adapterInfo: [AdapterData]?
    @Published var isAdapterConnected = false
    @Published var adapterConnectionSuccess :AdapterConnect = .none
    private var isSentBatteryCapacityAlarmMode = false
    private var isSentBatteryChargingErorAlarmMode = false
    //일반 설정값들
    private var systemPreferenceService: SystemPreferenceAccessible
    private var appSmartBatteryService: ProvidableType
    private var appSettingService: AppSmartSettingProvidable
    private var appProcessService: AppSmartProcessProvidable
    private var appChargingErrorCounrt = 0
    private var timer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    init(appSmartBatteryService: ProvidableType,appSettingService:AppSmartSettingProvidable,appProcessService: AppSmartProcessProvidable,   systemPreferenceService: SystemPreferenceAccessible) {
        self.appSmartBatteryService = appSmartBatteryService
        self.appSettingService = appSettingService
        self.appProcessService = appProcessService
        self.systemPreferenceService =  systemPreferenceService
    }
    //충전기 Off시 배터리 정보만 나타내는 함수
    private func requestBatteryInfo() {
        Publishers.CombineLatest(
            appSmartBatteryService.getPowerSourceValue(for: .batteryHealth, defaultValue: ""),
            appSmartBatteryService.getRegistry(forKey: .BatteryCellDisconnectCount).compactMap { $0 as? Int }
        )
        .sink { [weak self] healthState, batteryCellDisconnectCount in
            guard let self = self else { return }
            if self.healthState != healthState {
                self.healthState = healthState
            }
            if self.batteryCellDisconnectCount != batteryCellDisconnectCount {
                self.batteryCellDisconnectCount = batteryCellDisconnectCount
            }
        }
        .store(in: &cancellables)    }
}
extension SmartBatteryViewModel {
    func startConnectTimer() {
        timer = Timer.publish(every: 3, on: .current, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkAdapterConnectionStatus()
            }
        timer?.store(in: &cancellables)
    }
    func stopConnectTimer() {
        timer?.cancel()
        timer = nil
        cancellables.removeAll()
    }
    //처음 로드되면 밑에 할당되는 배터리 정보
    func requestStaticBatteryInfo() {
        Publishers.CombineLatest4(
            appSmartBatteryService.getRegistry(forKey: .CycleCount).compactMap { $0 as? Int },
            appSmartBatteryService.getRegistry(forKey: .Temperature).compactMap { $0 as? Int },
            appSmartBatteryService.getRegistry(forKey: .DesignCapacity).compactMap { $0 as? Int },
            appSmartBatteryService.getRegistry(forKey: .AppleRawMaxCapacity).compactMap { $0 as? Int }
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] cycleCount, temperature, designedCapacity, batteryMaxCapacity in
            guard let self = self else { return }
            if self.cycleCount != cycleCount {
                self.cycleCount = cycleCount
            }
            if self.temperature != temperature {
                self.temperature = temperature
            }
            if self.designedCapacity != designedCapacity {
                self.designedCapacity = designedCapacity
            }
            if self.batteryMaxCapacity != batteryMaxCapacity {
                self.batteryMaxCapacity = batteryMaxCapacity
            }
        }
        .store(in: &cancellables)
        
    }
    //어댑터 연결상태에 따라 정보가 변하는 함수
    func checkAdapterConnectionStatus() {
        checkSettingConfig()
        
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
                if chargeData.count > 5 {
                    chargeData.removeAll()
                }
                chargeData.append(charge)
                appChargingErrorCounrt += 1
            }
            .store(in: &cancellables)
        
        Publishers.Zip(
            appSmartBatteryService.getRegistry(forKey: .TimeRemaining).compactMap { $0 as? Int },
            appSmartBatteryService.getPowerSourceValue(for: .chargingTime, defaultValue: 0)
        )
        .sink { [weak self] remainingTime, chargingTime in
            guard let self = self else { return }
            self.remainingTime = remainingTime
            self.chargingTime = chargingTime
        }
        .store(in: &cancellables)
        
        
        appSmartBatteryService.getRegistry(forKey: .IsCharging)
            .subscribe(on: DispatchQueue.global())
            .compactMap { $0 as? Bool }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isCharging in
                guard let self = self else { return }
                if self.isCharging != isCharging {
                    self.isCharging = isCharging
                }
            }
            .store(in: &cancellables)
        appSmartBatteryService.getRegistry(forKey: .CurrentCapacity)
            .subscribe(on: DispatchQueue.global())
            .compactMap { $0 as? Int }
            .map { Double($0) / 100.0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentCapacity in
                guard let self = self else { return }
                if self.currentBatteryCapacity != currentCapacity  {
                    self.currentBatteryCapacity = currentCapacity
                }
            }
            .store(in: &cancellables)
        
        appSmartBatteryService.getRegistry(forKey: .AppleRawAdapterDetails)
            .subscribe(on: DispatchQueue.global())
            .tryMap { value -> Data in
                guard let value = value else {
                    throw AdapterConnect.dataNotFound
                }
                return try JSONSerialization.data(withJSONObject: value, options: [])
            }
            .decode(type: [AdapterData].self, decoder: JSONDecoder())
            .mapError { error -> AdapterConnect in
                switch error {
                default:
                    return .unknown(error)
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(_) = completion {
                        self.adapterConnectionSuccess = .decodingFailed
                    }
                },
                receiveValue: { [weak self] adapterDetails in
                    guard let self = self else {return }
                    let adapterConnected = adapterDetails.count == 0 ?  false : true
                    if adapterConnected {
                    } else {
                        requestBatteryInfo()
                    }
                    
                    if isAdapterConnected != adapterConnected {
                        isAdapterConnected = adapterConnected
                    }
                    adapterInfo = adapterDetails
                    adapterConnectionSuccess = .processing
                }
            )
            .store(in: &cancellables)
    }
    func checkSettingConfig() {
        if let isBatteryWarningMode: Bool = appSettingService.loadConfig(.isBatteryWarningMode) {
            if isBatteryWarningMode {
                if let lastChargeData = chargeData.last, lastChargeData.notChargingReason != 0,
                    appChargingErrorCounrt >= 6  && !isSentBatteryChargingErorAlarmMode {
                    AppNotificationManager.shared.sendNotification(title: "배터리 오류 발생", subtitle: "errorCode: \(lastChargeData.notChargingReason)")
                    isSentBatteryChargingErorAlarmMode = true
                }
            }
        }
        if let isBattryCurrentMessageMode: Bool = appSettingService.loadConfig(.isBattryCurrentMessageMode) {
            if isBattryCurrentMessageMode {
                if let batteryPercentage: String = appSettingService.loadConfig(.batteryPercentage) {
                    let batteryDobulePercentage = (Double(batteryPercentage) ?? 0) / 100
                    if batteryDobulePercentage <= currentBatteryCapacity {
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

