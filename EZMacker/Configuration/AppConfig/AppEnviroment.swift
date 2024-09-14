//
//  AppEnviroment.swift
//  EZMacker
//
//  Created by 박유경 on 9/14/24.
//

import Foundation

class AppEnvironment {
    static let shared = AppEnvironment()
    var isSandboxed: Bool
    var macBookType: MacType
    
    private init() {
        self.isSandboxed = AppConfigType.sandboxID.isActivated
        self.macBookType = MacType.from(identifier: Self.getMacModelIdentifier())
    }
    
    private static func getMacModelIdentifier() -> String {
        var size = 0
        sysctlbyname("hw.model", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.model", &machine, &size, nil, 0)
        return String(cString: machine)
    }
}
