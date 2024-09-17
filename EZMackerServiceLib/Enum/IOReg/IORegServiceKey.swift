//
//  IORegServiceKey.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 9/17/24.
//

public enum IORegServiceKey {
    case wifiService
    case batteryService
    
    public var value: String {
        switch self {
        case .wifiService:
            return "AppleBCMWLANSkywalkInterface"
        case .batteryService:
            return "AppleSmartBattery"
        }
    }
}
