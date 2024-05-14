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
    @Published var isCharging = false
    @Published var temperature = 0
    @Published var currentBatteryCapacity = 0
    @Published var remainingTime = 0
    @Published var chargingTime = 0
    @Published var cycleCount = 0
    @Published var maxCapacity = 0
    @Published var healthState = ""
    @Published var batteryMaxCapacity = 0
    @Published var designedCapacity = 0
    @Published var batteryCellDisconnectCount = 0
    
    @Published var isAdapterConnected = false
    
    
    
    private var appSmartBatteryService: AppSmartBatteryRegistryProvidable
    private var timer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    init(appSmartBatteryService: AppSmartBatteryService) {
        self.appSmartBatteryService = appSmartBatteryService
        
        timer = Timer.publish(every: 1, on: .current, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                self?.requestBatteryStatus()
            }
        timer?.store(in: &cancellables)
    }
    
    private func requestBatteryStatus() {
        
        appSmartBatteryService.getRegistry(forKey: .Temperature)
            .compactMap { $0 as? Int }
            .assign(to: \.temperature, on: self)
            .store(in: &cancellables)
        
        appSmartBatteryService.getRegistry(forKey: .IsCharging)
            .compactMap { $0 as? Bool }
            .assign(to: \.isCharging, on: self)
            .store(in: &cancellables)
        
        appSmartBatteryService.getRegistry(forKey: .CycleCount)
            .compactMap { $0 as? Int }
            .assign(to: \.cycleCount, on: self)
            .store(in: &cancellables)
        
        appSmartBatteryService.getRegistry(forKey: .CurrentCapacity)
            .compactMap { $0 as? Int }
            .assign(to: \.currentBatteryCapacity, on: self)
            .store(in: &cancellables)
        
        appSmartBatteryService.getRegistry(forKey: .AppleRawMaxCapacity)
            .compactMap { $0 as? Int }
            .assign(to: \.batteryMaxCapacity, on: self)
            .store(in: &cancellables)
        
        appSmartBatteryService.getPowerSourceValue(for: .batteryHealth, defaultValue: "")
            .assign(to: \.healthState, on: self)
            .store(in: &cancellables)
        
        appSmartBatteryService.getRegistry(forKey: .DesignCapacity)
            .compactMap { $0 as? Int }
            .assign(to: \.designedCapacity, on: self)
            .store(in: &cancellables)
        
        
        appSmartBatteryService.getRegistry(forKey: .BatteryCellDisconnectCount)
            .compactMap { $0 as? Int }
            .assign(to: \.batteryCellDisconnectCount, on: self)
            .store(in: &cancellables)
        
        
        appSmartBatteryService.getRegistry(forKey: .AdapterDetails)
            .sink { [weak self] data in
                guard let self = self else { return }
                if let unwrappedData = data as? [String: Any], let familyCode = unwrappedData["FamilyCode"] as? Int {
                    if familyCode == 0 {
                        self.isAdapterConnected = false
                    } else {
                        self.isAdapterConnected = true
                    }
                }
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest(appSmartBatteryService.getPowerSourceValue(for: .remainingTime, defaultValue: 0), appSmartBatteryService.getPowerSourceValue(for: .chargingTime, defaultValue: 0))
            .sink { [weak self] remainingTime, chargingTime in
                self?.remainingTime = remainingTime
                self?.chargingTime = chargingTime
                print(remainingTime)
                print(chargingTime)
            }
            .store(in: &cancellables)
    }
}
