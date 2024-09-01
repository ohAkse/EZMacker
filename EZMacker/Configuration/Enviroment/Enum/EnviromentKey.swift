//
//  EnviromentKey.swift
//  EZMacker
//
//  Created by 박유경 on 8/17/24.
//

import Foundation

enum EnvironmentKey: String {
    case sandboxID = "APP_SANDBOX_CONTAINER_ID"
    case macModel = "hw.model"
    
    var key: String? {
        switch self {
        case .sandboxID:
            return ProcessInfo.processInfo.environment[self.rawValue]
        case .macModel:
            return getMacModel()
        }
    }
    
    var isActivated: Bool {
        key != nil
    }
    
    private func getMacModel() -> String? {
        var size = 0
        sysctlbyname(self.rawValue, nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: size)
        sysctlbyname(self.rawValue, &machine, &size, nil, 0)
        return String(cString: machine)
    }
}
