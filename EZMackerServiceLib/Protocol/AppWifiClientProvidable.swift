//
//  AppWifiClientProvidable.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 9/4/24.
//
import CoreWLAN

public protocol AppWiFiClientProvidable {
    var wifiClient: CWWiFiClient { get }
}
