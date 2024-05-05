//
//  SmartFileViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import Foundation
class SmartFileViewModel: ObservableObject {
    private let appSmartFileSerivce: AppSmartFileProvidable
    
    init(appSmartFileService: AppSmartFileProvidable) {
        self.appSmartFileSerivce = appSmartFileService
        appSmartFileService.getFileList()
    }
}
