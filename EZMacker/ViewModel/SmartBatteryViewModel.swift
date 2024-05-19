//
//  SmartBatteryViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//
import Combine
import SwiftUI

class SmartBatteryViewModel: ObservableObject {
    
    deinit {
        timer?.cancel()
        cancellables.removeAll()
        print("SmartBatteryViewModel deinit Called")
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
    
    
    private var appSmartBatteryService: AppSmartBatteryRegistryProvidable
    private var timer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    init(appSmartBatteryService: AppSmartBatteryService) {
        self.appSmartBatteryService = appSmartBatteryService
        
        requestBatteryStatus()
        
        timer = Timer.publish(every: 1, on: .current, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.requestBatteryStatus()
            }
        timer?.store(in: &cancellables)
    }
    
    private func requestBatteryStatus() {
        //Registry
        appSmartBatteryService.getRegistry(forKey: .Temperature)
            .subscribe(on: DispatchQueue.global())
            .compactMap { $0 as? Int }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }
                if self.temperature != newValue {
                    self.temperature = newValue
                }
            }
            .store(in: &cancellables)
        
        appSmartBatteryService.getRegistry(forKey: .IsCharging)
            .subscribe(on: DispatchQueue.global())
            .compactMap { $0 as? Bool }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }
                if self.isCharging != newValue {
                    self.isCharging = newValue
                }
            }
            .store(in: &cancellables)
        
        appSmartBatteryService.getRegistry(forKey: .CycleCount)
            .subscribe(on: DispatchQueue.global())
            .compactMap { $0 as? Int }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }
                if self.cycleCount != newValue {
                    self.cycleCount = newValue
                }
            }
            .store(in: &cancellables)
        
        appSmartBatteryService.getRegistry(forKey: .CurrentCapacity)
            .subscribe(on: DispatchQueue.global())
            .compactMap { $0 as? Int }
            .map { Double($0) / 100.0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }
                if self.currentBatteryCapacity != newValue {
                    self.currentBatteryCapacity = newValue
                }
            }
            .store(in: &cancellables)
        
        appSmartBatteryService.getRegistry(forKey: .AppleRawMaxCapacity)
            .subscribe(on: DispatchQueue.global())
            .compactMap { $0 as? Int }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }
                if self.batteryMaxCapacity != newValue {
                    self.batteryMaxCapacity = newValue
                }
            }
            .store(in: &cancellables)
        
        appSmartBatteryService.getRegistry(forKey: .DesignCapacity)
            .subscribe(on: DispatchQueue.global())
            .compactMap { $0 as? Int }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }
                if self.designedCapacity != newValue {
                    self.designedCapacity = newValue
                }
            }
            .store(in: &cancellables)
        
        appSmartBatteryService.getRegistry(forKey: .BatteryCellDisconnectCount)
            .subscribe(on: DispatchQueue.global())
            .compactMap { $0 as? Int }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }
                if self.batteryCellDisconnectCount != newValue {
                    self.batteryCellDisconnectCount = newValue
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
                    if case .failure(let error) = completion {
                        Logger.writeLog(.info, message: "Failed to fetch or decode data: \(error)")
                        self.adapterConnectionSuccess = .decodingFailed
                    }
                },
                receiveValue: { [weak self] adapterDetails in
                    
                    let adapterConnected = adapterDetails.count == 0 ?  false : true
                    if self?.isAdapterConnected != adapterConnected {
                        self?.isAdapterConnected = adapterConnected
                    }
                    self?.adapterInfo = adapterDetails
                    self?.adapterConnectionSuccess = .processing
                }
            )
            .store(in: &cancellables)
        
        //PowerSource
        
        appSmartBatteryService.getRegistry(forKey: .BatteryCellDisconnectCount)
            .subscribe(on: DispatchQueue.global())
            .compactMap { $0 as? Int }
            .receive(on: DispatchQueue.main)
            .assign(to: \.batteryCellDisconnectCount, on: self)
            .store(in: &cancellables)
        
        
        Publishers.CombineLatest(
            appSmartBatteryService.getPowerSourceValue(for: .remainingTime, defaultValue: 0),
            appSmartBatteryService.getPowerSourceValue(for: .chargingTime, defaultValue: 0)
        )
        .sink { [weak self] remainingTime, chargingTime in
            guard let self = self else { return }
            if self.remainingTime != remainingTime {
                self.remainingTime = remainingTime
                Logger.writeLog(.info, message: "\(self.remainingTime)")
            }
            if self.chargingTime != chargingTime {
                self.chargingTime = chargingTime
                Logger.writeLog(.info, message: "\(self.chargingTime)")
            }
        }
        .store(in: &cancellables)
        
    }
}
