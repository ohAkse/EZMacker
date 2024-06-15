//
//  ScanningWifiData.swift
//  EZMacker
//
//  Created by 박유경 on 6/3/24.
//

import Foundation

struct ScaningWifiData: Identifiable {
    let id = UUID()
    let ssid: String
    let rssi: String
}
