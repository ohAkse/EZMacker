//
//  EnviromentKey.swift
//  EZMacker
//
//  Created by 박유경 on 8/17/24.
//

import Foundation

enum EnvironmentKey: String {
    case sandboxID = "APP_SANDBOX_CONTAINER_ID"
    
    var key: String? {
        ProcessInfo.processInfo.environment[self.rawValue]
    }
    
    var isActivated: Bool {
        key != nil
    }
}
