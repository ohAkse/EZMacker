//
//  AppWifiKeyChainService.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 9/1/24.
//

import Foundation
import EZMackerUtilLib

public protocol AppWifiKeyChainProvidable {
    func savePassword(service: String, account: String, password: String) -> Bool
    func getPassword(service: String, account: String) -> String?
}

public class AppWifiKeyChainService: AppWifiKeyChainProvidable {
    public init() {}
    
    public func savePassword(service: String, account: String, password: String) -> Bool {
        let data = password.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
         Logger.writeLog(.info, message: "savePassword Success? -> \(status == errSecSuccess)")
        return status == errSecSuccess
    }
    
    public func getPassword(service: String, account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(decoding: data, as: UTF8.self)
        }
        
        return nil
    }
}

