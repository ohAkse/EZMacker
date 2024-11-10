//
//  CWPHYMode + Extension.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 10/13/24.
//
import CoreWLAN

public extension CWPHYMode {
    var description: String {
        switch self {
        case .modeNone:
            return "None"
        case .mode11a:
            return "802.11a"
        case .mode11b:
            return "802.11b"
        case .mode11g:
            return "802.11g"
        case .mode11n:
            return "802.11n"
        case .mode11ac:
            return "802.11ac"
        case .mode11ax:
            return "802.11ax"
        @unknown default:
            return "Unknown"
        }
    }
}
