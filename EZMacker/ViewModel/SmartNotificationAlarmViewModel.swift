//
//  NotificationAlarmViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 5/13/24.
//

import SwiftUI
import Combine
import EZMackerUtilLib
import EZMackerServiceLib

class SmartNotificationAlarmViewModel: ObservableObject {

    // MARK: - Published Variable
    @Published var batterySetting: BatterySettingConfigurable
    @Published var wifiSetting: WifiSettingConfigurable
    @Published var fileLocatorSetting: FileLocatorSettingConfigurable
    
    // MARK: - Service Variable
    private let appSettingService: AppSettingProvidable
    private let appProcessService: AppSmartProcessProvidable
    private(set) var cancellables = Set<AnyCancellable>()
    
    deinit {
        Logger.writeLog(.debug, message: "NotificationAlarmViewModel deinit Called")
    }
    init(appSettingService: AppSettingProvidable, appProcessService: AppSmartProcessProvidable, batterySetting: BatterySettingConfigurable, wifiSetting: WifiSettingConfigurable, fileLocatorSetting: FileLocatorSettingConfigurable ) {
        self.appSettingService = appSettingService
        self.appProcessService = appProcessService
        self.batterySetting = batterySetting
        self.wifiSetting = wifiSetting
        self.fileLocatorSetting = fileLocatorSetting
        Logger.writeLog(.debug, message: "ee")
    }
    
    // MARK: - Configuration
    func loadConfig() {
        batterySetting = BatterySetting(
            isBatteryWarningMode: loadSetting(.isBatteryChargingErrorMode) ?? false,
            isBatteryCurrentMessageMode: loadSetting(.isBatteryFullCapacityAlarmeMode) ?? false,
            batteryPercentage: loadSetting(.batteryPercentage) ?? "1",
            cpuUsageExitType: loadSetting(.cpuUsageExitType).flatMap { CPUUsageExitType(rawValue: $0) } ?? .unused
        )
        wifiSetting = WifiSetting(
            selectedSSIDShowOption: loadSetting(.ssidShowType).flatMap { SSIDShowType(rawValue: $0) } ?? .alert,
            ssidFindTimer: loadSetting(.ssidFindTimer) ?? "1"
        )
        fileLocatorSetting = FileLocatorSetting(
            isFileChangeAlarmDisabled: loadSetting(.isFileChangeAlarmDisabled) ?? false
        )
    }
        
    func saveConfig() {
        // MARK: Battery
        saveSetting(.isBatteryChargingErrorMode, value: batterySetting.isBatteryWarningMode)
        saveSetting(.isBatteryFullCapacityAlarmeMode, value: batterySetting.isBatteryCurrentMessageMode)
        saveSetting(.batteryPercentage, value: batterySetting.batteryPercentage)
        saveSetting(.cpuUsageExitType, value: batterySetting.cpuUsageExitType.rawValue)
        // MARK: WIFI Setting
        saveSetting(.ssidShowType, value: wifiSetting.selectedSSIDShowOption.rawValue)
        saveSetting(.ssidFindTimer, value: wifiSetting.ssidFindTimer)
        // MARK: File Locator Setting
        saveSetting(.isFileChangeAlarmDisabled, value: fileLocatorSetting.isFileChangeAlarmDisabled)
    }
    
    private func loadSetting<T>(_ key: AppStorageKey) -> T? {
        appSettingService.loadConfig(key)
    }
    
    private func saveSetting<T>(_ key: AppStorageKey, value: T) {
        appSettingService.saveConfig(key, value: value)
    }
}
