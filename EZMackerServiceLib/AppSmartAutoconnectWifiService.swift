//
//  AppSmartAutoconnectWifiService.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 9/5/24.
//

import Foundation
import Security
import EZMackerUtilLib

public protocol AppSmartAutoconnectWifiServiceProvidable {
    func savePassword(_ password: String, for ssid: String)
    func getPassword(for ssid: String) -> String?
    func deletePassword(for ssid: String)
}

public class AppSmartAutoconnectWifiService: AppSmartAutoconnectWifiServiceProvidable {
    private let service = "com.ezmacker.wifipasswords"
    public init() {}
    
    public func savePassword(_ password: String, for ssid: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: ssid,
            kSecValueData as String: password.data(using: .utf8)!
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            Logger.writeLog(.error, message: "Failed to save password: \(status)")
        }
    }
    
    public func getPassword(for ssid: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: ssid,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess,
              let passwordData = item as? Data else {
            return nil
        }
        
        return String.Encoding.utf8.decode(passwordData)
    }
    public func deletePassword(for ssid: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: ssid
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess && status != errSecItemNotFound {
            Logger.writeLog(.error, message: "Failed to delete password")
        }
    }
}
