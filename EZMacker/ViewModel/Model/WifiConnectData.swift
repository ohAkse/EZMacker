//
//  WifiConnectData.swift
//  EZMacker
//
//  Created by 박유경 on 8/24/24.
//

import Foundation
import EZMackerServiceLib

struct WifiConnectData {
    var strength: Int
    var transmitRate: String
    var scanningWifiList: [ScaningWifiData]
    var connectedSSid: String
    
    // Detail
    var interfaceName: String
    var activePHYMode: String
    var powerOn: Bool
    var supportedWLANChannels: [String]
    var bssid: String
    var noiseMeasurement: Int
    var security: String
    var interfaceMode: String
    var serviceActive: Bool
    var beaconInterval: String
    var eventType: String
    var eventDetails: String
    
    init(
        strength: Int = 0,
        transmitRate: String = "",
        scanningWifiList: [ScaningWifiData] = [],
        connectedSSid: String = "",
        interfaceName: String = "",
        activePHYMode: String = "",
        powerOn: Bool = false,
        supportedWLANChannels: [String] = [],
        bssid: String = "",
        noiseMeasurement: Int = 0,
        security: String = "",
        interfaceMode: String = "",
        serviceActive: Bool = false,
        beaconInterval: String = "",
        eventType: String = "",
        eventDetails: String = ""
    ) {
        self.strength = strength
        self.transmitRate = transmitRate
        self.scanningWifiList = scanningWifiList
        self.connectedSSid = connectedSSid
        self.interfaceName = interfaceName
        self.activePHYMode = activePHYMode
        self.powerOn = powerOn
        self.supportedWLANChannels = supportedWLANChannels
        self.bssid = bssid
        self.noiseMeasurement = noiseMeasurement
        self.security = security
        self.interfaceMode = interfaceMode
        self.serviceActive = serviceActive
        self.beaconInterval = beaconInterval
        self.eventType = eventType
        self.eventDetails = eventDetails
    }
}
