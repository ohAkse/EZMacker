//
//  WifiConnectData.swift
//  EZMacker
//
//  Created by 박유경 on 8/24/24.
//

import Foundation

struct WifiConnectData {
    var strength: Int
    var transmitRate: String
    var scanningWifiList: [ScaningWifiData]
    var connectedSSid: String
    init(strength: Int = 0, transmitRate: String = "", scanningWifiList: [ScaningWifiData] = [], connectedSSid: String = "") {
        self.strength = strength
        self.transmitRate = transmitRate
        self.scanningWifiList = scanningWifiList
        self.connectedSSid = connectedSSid
    }
}
