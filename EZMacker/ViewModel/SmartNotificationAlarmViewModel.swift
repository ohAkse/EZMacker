//
//  NotificationAlarmViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 5/13/24.
//


import SwiftUI
import Combine

class SmartNotificationAlarmViewModel: ObservableObject {
    //Battery
    @Published var isBatteryWarningMode = false
    @Published var isBattryCurrentMessageMode = false
    @Published var batteryPercentage: String = ""
    @Published var selectedAppExitOption = AppUsageExitOption.normal
    
    //Wifi
    @Published var selectedBestSSidOption = BestSSIDShowOption.alert
    
    private var appSettingService: AppSmartSettingProvidable
    private var appProcessService: AppSmartProcessProvidable
    private var cancellables = Set<AnyCancellable>()
    deinit {
        Logger.writeLog(.debug, message: "NotificationAlarmViewModel deinit Called")
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
         if let selectedExitMode: String = appSettingService.loadConfig(.appExitMode) {
             self.selectedAppExitOption = AppUsageExitOption(rawValue: selectedExitMode) ?? .unused
         }
        if let selectedBestSSidMode: String = appSettingService.loadConfig(.bestSSidShowMode) {
            self.selectedBestSSidOption = BestSSIDShowOption(rawValue: selectedBestSSidMode) ?? .alert
         }
    }
        
    func saveConfig() {
        appSettingService.saveConfig(.isBatteryWarningMode, value: isBatteryWarningMode)
        appSettingService.saveConfig(.isBattryCurrentMessageMode, value: isBattryCurrentMessageMode)
        appSettingService.saveConfig(.batteryPercentage, value: batteryPercentage)
        appSettingService.saveConfig(.appExitMode, value: selectedAppExitOption.value)
        appSettingService.saveConfig(.bestSSidShowMode, value: selectedBestSSidOption.value)
    }
}
