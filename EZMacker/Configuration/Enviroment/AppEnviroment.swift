//
//  AppEnviroment.swift
//  EZMacker
//
//  Created by 박유경 on 8/17/24.
//

import Foundation

class AppEnvironment {
    static let shared = AppEnvironment()
    
    private(set) var isSandboxed: Bool
    
    private init() {
        self.isSandboxed = EnvironmentKey.sandboxID.isActivated
    }
}
