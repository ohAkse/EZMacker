//
//  SmartWifi + Inject.swift
//  EZMacker
//
//  Created by 박유경 on 10/13/24.
//

import EZMackerServiceLib

protocol SmartWifiInjectable {
    var radioChannelData: RadioChannelData { get }
    var wificonnectData: WifiConnectData { get }
}
extension SmartWifiViewModel: SmartWifiInjectable {}
