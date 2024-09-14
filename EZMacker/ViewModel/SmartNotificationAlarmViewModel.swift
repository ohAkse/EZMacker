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
    }
    
    // MARK: - Configuration
    func loadConfig() {
        batterySetting = BatterySetting(
            isBatteryWarningMode: loadSetting(.isBatteryChargingErrorMode) ?? false,
            isBatteryCurrentMessageMode: loadSetting(.isBatteryCurrentMessageMode) ?? false,
            batteryPercentage: loadSetting(.batteryPercentage) ?? "",
            cpuUsageExitType: loadSetting(.cpuUsageExitType).flatMap { CPUUsageExitType(rawValue: $0) } ?? .unused
        )
        wifiSetting = WifiSetting(
            selectedBestSSIDOption: loadSetting(.bestSSIDShowType).flatMap { BestSSIDShowType(rawValue: $0) } ?? .alert
        )
        fileLocatorSetting = FileLocatorSetting(
            isFileChangeAlarmDisabled: loadSetting(.isFileChangeAlarmDisabled) ?? false
        )
    }
        
    func saveConfig() {
        saveSetting(.isBatteryChargingErrorMode, value: batterySetting.isBatteryWarningMode)
        saveSetting(.isBatteryCurrentMessageMode, value: batterySetting.isBatteryCurrentMessageMode)
        saveSetting(.batteryPercentage, value: batterySetting.batteryPercentage)
        saveSetting(.cpuUsageExitType, value: batterySetting.cpuUsageExitType.rawValue)
        saveSetting(.bestSSIDShowType, value: wifiSetting.selectedBestSSIDOption.rawValue)
        saveSetting(.isFileChangeAlarmDisabled, value: fileLocatorSetting.isFileChangeAlarmDisabled)
    }
    
    private func loadSetting<T>(_ key: AppStorageKey) -> T? {
        appSettingService.loadConfig(key)
    }
    
    private func saveSetting<T>(_ key: AppStorageKey, value: T) {
        appSettingService.saveConfig(key, value: value)
    }
}
