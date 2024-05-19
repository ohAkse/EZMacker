//
//  SystemSettingPreference.swift
//  EZMacker
//
//  Created by 박유경 on 5/19/24.
//

import Foundation
//https://stackoverflow.com/questions/52751941/how-to-launch-system-preferences-to-a-specific-preference-pane-using-bundle-iden


enum SystemPreference: String{
    case batterySave, network, blueTooth, wifi
    
    var pathString: String {
        if #available(macOS 12, *) {
            switch self {
            case .batterySave: return "x-apple.systempreferences:com.apple.Battery-Settings.extension"
            case .network: return "x-apple.systempreferences:com.apple.Network-Settings.extension"
            case .blueTooth: return "x-apple.systempreferences:com.apple.BluetoothSettings"
            case .wifi: return "x-apple.systempreferences:com.apple.wifi-settings-extension"
            }
        }
    }
}
