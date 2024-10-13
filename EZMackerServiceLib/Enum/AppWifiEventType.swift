//
//  AppWifiEventType.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 10/13/24.
//

public enum AppWifiEventType {
    case ssidChanged(String)
    case bssidChanged(String)
    case linkChanged(String)
    case modeChanged(String)
    case powerChanged(String)
    case scanCacheUpdated(String)
}
