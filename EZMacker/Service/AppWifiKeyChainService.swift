//
//  AppWifiKeyChainService.swift
//  EZMacker
//
//  Created by 박유경 on 6/11/24.
//

import Foundation
import Security

protocol AppWifiKeyChainProvidable {
    func savePassword(service: String, account: String, password: String) -> Bool
    func getPassword(service: String, account: String) -> String?
}

class AppWifiKeyChainService: AppWifiKeyChainProvidable {
     func savePassword(service: String, account: String, password: String) -> Bool {
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
    
     func getPassword(service: String, account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }
}
