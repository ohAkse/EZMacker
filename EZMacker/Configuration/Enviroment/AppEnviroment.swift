//
//  AppEnviroment.swift
//  EZMacker
//
//  Created by 박유경 on 8/17/24.
//

import Foundation

// 맥미니/맥북, pInfo 관련된 정보가 다름으로 인해 기능의 문제가 있을시 분기처리하기 위해 싱글톤으로 생성
class AppEnvironment {
    static let shared = AppEnvironment()
    
    var isSandboxed: Bool
    var macBookType: MacBookType
    
    private init() {
        self.isSandboxed = EnvironmentKey.sandboxID.isActivated
        self.macBookType = MacBookType.from(identifier: Self.getMacModelIdentifier())
    }
    
    private static func getMacModelIdentifier() -> String {
        var size = 0
        sysctlbyname("hw.model", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.model", &machine, &size, nil, 0)
        return String(cString: machine)
    }
}
