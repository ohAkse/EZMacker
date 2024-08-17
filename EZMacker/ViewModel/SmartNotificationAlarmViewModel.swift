//
//  NotificationAlarmViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 5/13/24.
//

import SwiftUI
import Combine

class SmartNotificationAlarmViewModel: ObservableObject {

    // MARK: - Published Variable
    @Published var batterySetting: BatterySettingConfigurable
    @Published var wifiSetting: WifiSettingConfigurable
    @Published var fileLocatorSetting: FileLocatorSettingConfigurable
    
    // MARK: - Service Variable
    private let appSettingService: AppSmartSettingProvidable
    private let appProcessService: AppSmartProcessProvidable
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        Logger.writeLog(.debug, message: "NotificationAlarmViewModel deinit Called")
    }
    init(appSettingService: AppSmartSettingsService, appProcessService: AppSmartProcessProvidable, batterySetting:BatterySettingConfigurable, wifiSetting: WifiSettingConfigurable, fileLocatorSetting: FileLocatorSettingConfigurable ) {
        self.appSettingService = appSettingService
        self.appProcessService = appProcessService
        self.batterySetting = batterySetting
        self.wifiSetting = wifiSetting
        self.fileLocatorSetting = fileLocatorSetting
    }
    
    
    // MARK: - Configuration
    func loadConfig() {
        batterySetting = BatterySetting(
            isBatteryWarningMode: loadSetting(.isBatteryWarningMode) ?? false,
            isBatteryCurrentMessageMode: loadSetting(.isBattryCurrentMessageMode) ?? false,
            batteryPercentage: loadSetting(.batteryPercentage) ?? "",
            selectedAppExitOption: loadSetting(.appExitMode).flatMap { AppUsageExit(rawValue: $0) } ?? .normal
        )
        wifiSetting = WifiSetting(
            selectedBestSSIDOption: loadSetting(.bestSSidShowMode).flatMap { BestSSIDShow(rawValue: $0) } ?? .alert
        )
        fileLocatorSetting = FileLocatorSetting(
            isFileChangeAlarmDisabled: loadSetting(.isFileChangeAlarmDisabled) ?? false
        )
    }
        
    func saveConfig() {
        saveSetting(.isBatteryWarningMode, value: batterySetting.isBatteryWarningMode)
        saveSetting(.isBattryCurrentMessageMode, value: batterySetting.isBatteryCurrentMessageMode)
        saveSetting(.batteryPercentage, value: batterySetting.batteryPercentage)
        saveSetting(.appExitMode, value: batterySetting.selectedAppExitOption.rawValue)
        saveSetting(.bestSSidShowMode, value: wifiSetting.selectedBestSSIDOption.rawValue)
        saveSetting(.isFileChangeAlarmDisabled, value: fileLocatorSetting.isFileChangeAlarmDisabled)
    }
    
    private func loadSetting<T>(_ key: AppStorageKey) -> T? {
        appSettingService.loadConfig(key)
    }
    
    private func saveSetting<T>(_ key: AppStorageKey, value: T) {
        appSettingService.saveConfig(key, value: value)
    }
}
