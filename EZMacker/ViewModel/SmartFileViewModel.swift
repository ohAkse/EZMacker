//
//  SmartFileViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import Foundation
class SmartFileViewModel: ObservableObject {
    private let appSmartFileSerivce: AppSmartFileProvidable
    private let systemPreferenceService: SystemPreferenceAccessible
    deinit {
        print("SmartFileViewModel deinit Called")
    }
    
    init(appSmartFileService: AppSmartFileProvidable, systemPreferenceService: SystemPreferenceAccessible) {
        self.appSmartFileSerivce = appSmartFileService
        self.systemPreferenceService = systemPreferenceService
    }
}
