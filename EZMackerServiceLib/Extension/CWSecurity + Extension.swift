//
//  CWSecurity + Extension.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 10/13/24.
//

import CoreWLAN

public extension CWSecurity {
    var description: String {
        switch self {
        case .none:
            return "None"
        case .WEP:
            return "WEP"
        case .wpaPersonal:
            return "WPA Personal"
        case .wpaPersonalMixed:
            return "WPA Personal Mixed"
        case .wpa2Personal:
            return "WPA2 Personal"
        case .personal:
            return "Personal"
        case .dynamicWEP:
            return "Dynamic WEP"
        case .wpaEnterprise:
            return "WPA Enterprise"
        case .wpaEnterpriseMixed:
            return "WPA Enterprise Mixed"
        case .wpa2Enterprise:
            return "WPA2 Enterprise"
        case .enterprise:
            return "Enterprise"
        case .wpa3Personal:
            return "WPA3 Personal"
        case .wpa3Enterprise:
            return "WPA3 Enterprise"
        case .wpa3Transition:
            return "WPA3 Transition"
        case .OWE:
            return "OWE"
        case .oweTransition:
            return "OWE Transition"
        case .unknown:
            return "Unknown"
        @unknown default:
            return "Unknown"
        }
    }
}
