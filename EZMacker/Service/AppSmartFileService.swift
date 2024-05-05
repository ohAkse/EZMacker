//
//  AppSmartFileService.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import Foundation
protocol AppSmartFileProvidable {
    func getFileList()
}

struct AppSmartFileService: AppSmartFileProvidable {
    func getFileList() {
        print("AppSmartFileService getFileList called")
    }
}
