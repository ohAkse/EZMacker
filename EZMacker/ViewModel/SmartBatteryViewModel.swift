//
//  SmartBatteryViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//
import Combine
import Foundation

class SmartBatteryViewModel: ObservableObject {
    @Published var temperature = 0
    @Published var isCharging = false 
    
    deinit {
        timer?.cancel()
        cancellables.removeAll()
        print("SmartBatteryViewModel deinit Called")
    }
    
    private let appSmartBatteryService: AppSmartBatteryRegistryProvidable
    private var timer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    init(appSmartBatteryService: AppSmartBatteryService) {
        self.appSmartBatteryService = appSmartBatteryService
        
        timer = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                self?.requestBatteryStatus()
            }
        timer?.store(in: &cancellables)
    }
    
    private func requestBatteryStatus() {
        appSmartBatteryService.getRegistry(forKey: .Temperature)
            .compactMap { $0 as? Int }
            .print("Temperature")
            .assign(to: \.temperature, on: self)
            .store(in: &cancellables)

        appSmartBatteryService.getRegistry(forKey: .AbsoluteCapacity)
            .compactMap { $0 as? Int }
            .map { $0 > 0 }
            .print("isCharging")
            .assign(to: \.isCharging, on: self)
            .store(in: &cancellables)
    }
}
