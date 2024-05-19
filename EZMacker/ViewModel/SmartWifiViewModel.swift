//
//  SmartWifiViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 5/19/24.
//

import Foundation
class SmartWifiViewModel<ProvidableType: AppSmartWifiServiceProvidable>: ObservableObject {
    //private let smartWifiService: AppSmartWifiServiceProvidable
    private let smartWifiService: ProvidableType
    private let systemPreferenceService: SystemPreferenceAccessible
    deinit {
        Logger.writeLog(.info, message: "SmartWifiViewModel deinit Called")
    }
    
    init(appSmartWifiService: ProvidableType, systemPreferenceService: SystemPreferenceAccessible) {
        self.smartWifiService = appSmartWifiService
        self.systemPreferenceService = systemPreferenceService
    }
}
