//
//  NotificationAlarmViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 5/13/24.
//


import SwiftUI
import Combine

class SmartNotificationAlarmViewModel: ObservableObject {
    @Published var isBatteryWarningMode = false
    @Published var isBattryCurrentMessageMode = false
    @Published var batteryPercentage: String = ""
    @Published var selectedOption = BatteryExitOption.normal
    
    
    private var appSettingService: AppSmartSettingProvidable
    private var appProcessService: AppSmartProcessProvidable
    
    private var cancellables = Set<AnyCancellable>()
    deinit {
        Logger.writeLog(.info, message: "NotificationAlarmViewModel deinit Called")
    }
    init(appSettingService: AppSmartSettingsService, appProcessService: AppSmartProcessProvidable ) {
        self.appSettingService = appSettingService
        self.appProcessService = appProcessService
    }
    func loadConfig() {

        if let isBatteryWarningMode: Bool = appSettingService.loadConfig(.isBatteryWarningMode) {
             self.isBatteryWarningMode = isBatteryWarningMode
         }
        if let isBattryCurrentMessageMode: Bool = appSettingService.loadConfig(.isBattryCurrentMessageMode) {
             self.isBattryCurrentMessageMode = isBattryCurrentMessageMode
         }
         if let batteryPercentage: String = appSettingService.loadConfig(.batteryPercentage) {
             self.batteryPercentage = batteryPercentage
         }
         if let selectedOptionRaw: String = appSettingService.loadConfig(.appExitMode) {
             self.selectedOption = BatteryExitOption(rawValue: selectedOptionRaw) ?? .unused
         }
    }
        
    func saveConfig() {
        appSettingService.saveConfig(.isBatteryWarningMode, value: isBatteryWarningMode)
        appSettingService.saveConfig(.isBattryCurrentMessageMode, value: isBattryCurrentMessageMode)
        appSettingService.saveConfig(.batteryPercentage, value: batteryPercentage)
        appSettingService.saveConfig(.appExitMode, value: selectedOption.value)
    }
}
