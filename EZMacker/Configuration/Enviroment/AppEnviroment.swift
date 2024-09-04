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
    private(set) var isMacBook: Bool
    
    private init() {
        self.isSandboxed = EnvironmentKey.sandboxID.isActivated
        self.isMacBook = Self.checkIfMacBook()
    }
    
    private static func checkIfMacBook() -> Bool {
        guard let model = EnvironmentKey.macModel.key?.lowercased() else { return false }
        return model.contains("macbook") || model.contains("mini")
    }
}
