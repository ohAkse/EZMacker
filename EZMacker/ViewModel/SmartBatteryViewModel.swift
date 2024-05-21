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
        Logger.writeLog(.info, message: "SmartBatteryViewModel deinit Called")
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
    
    //어댑터 관련 설정값들
    @Published var adapterInfo: [AdapterDetails]?
    @Published var isAdapterConnected = false
    @Published var adapterConnectionSuccess :AdapterConnectStatus = .none
    
    //일반 설정값들
    private var systemPreferenceService: SystemPreferenceAccessible
    private var appSmartBatteryService: ProvidableType
    private var timer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    init(appSmartBatteryService: ProvidableType, systemPreferenceService: SystemPreferenceAccessible) {
        self.appSmartBatteryService = appSmartBatteryService
        self.systemPreferenceService =  systemPreferenceService
    }
    //충전기 Off시 배터리 정보만 나타내는 함수
    private func requestBatteryInfo() {
        Publishers.CombineLatest4(
            appSmartBatteryService.getPowerSourceValue(for: .remainingTime, defaultValue: 0),
            appSmartBatteryService.getPowerSourceValue(for: .chargingTime, defaultValue: 0),
            appSmartBatteryService.getPowerSourceValue(for: .batteryHealth, defaultValue:""),
            appSmartBatteryService.getRegistry(forKey: .BatteryCellDisconnectCount).compactMap { $0 as? Int }
        )
        .sink { [weak self] remainingTime, chargingTime, healthState, batteryCellDisconnectCount in
            guard let self = self else { return }
            if self.remainingTime != remainingTime {
                self.remainingTime = remainingTime
            }
            if self.chargingTime != chargingTime {
                self.chargingTime = chargingTime
            }
            if self.healthState != healthState {
                self.healthState = healthState
            }
            if self.batteryCellDisconnectCount != batteryCellDisconnectCount {
                self.batteryCellDisconnectCount = batteryCellDisconnectCount
            }
        }
        .store(in: &cancellables)
    }
}
extension SmartBatteryViewModel {
    func startConnectTimer() {
        
        timer = Timer.publish(every: 0.3, on: .current, in: .default)
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
        Publishers.CombineLatest(
            appSmartBatteryService.getRegistry(forKey: .IsCharging)
                .subscribe(on: DispatchQueue.global())
                .compactMap { $0 as? Bool },
            appSmartBatteryService.getRegistry(forKey: .CurrentCapacity)
                .subscribe(on: DispatchQueue.global())
                .compactMap { $0 as? Int }
                .map { Double($0) / 100.0 }
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] isCharging, currentBatteryCapacity in
            guard let self = self else { return }
            if self.isCharging != isCharging {
                self.isCharging = isCharging
            }
            if self.currentBatteryCapacity != currentBatteryCapacity {
                self.currentBatteryCapacity = currentBatteryCapacity
            }
        }
        .store(in: &cancellables)
        
        appSmartBatteryService.getRegistry(forKey: .AppleRawAdapterDetails)
            .subscribe(on: DispatchQueue.global())
            .tryMap { value -> Data in
                guard let value = value else {
                    throw AdapterConnectStatus.dataNotFound
                }
                return try JSONSerialization.data(withJSONObject: value, options: [])
            }
            .decode(type: [AdapterDetails].self, decoder: JSONDecoder())
            .mapError { error -> AdapterConnectStatus in
                switch error {
                case is DecodingError:
                    return .decodingFailed
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
    func openSettingWindow(settingPath: String) {
        systemPreferenceService.openSystemPreferences(systemPath: settingPath)
    }
}

