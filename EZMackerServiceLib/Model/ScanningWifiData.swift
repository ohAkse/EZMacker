//
//  ScanningWifiData.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 9/1/24.
//

import Foundation

public struct ScaningWifiData: Identifiable {
    public let id = UUID()
    public let ssid: String
    public let rssi: String
    public var isSaved: Bool
}
