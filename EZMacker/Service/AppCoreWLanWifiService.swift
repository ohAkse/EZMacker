//
//  AppCoreWLanWifiService.swift
//  EZMacker
//
//  Created by 박유경 on 5/27/24.
//

import CoreWLAN
import Combine

protocol AppCoreWLANWifiProvidable {
    func getSignalStrength() -> Future<Int, AppCoreWLanError>
    func getMbpsRate()-> Future<String, AppCoreWLanError>
    func getHardwareAddress()-> Future<String, AppCoreWLanError>
    func getWifiLists() -> Future<[ScaningWifiData], AppCoreWLanError>
}

class AppCoreWLanWifiService: AppCoreWLANWifiProvidable {

    private var wifiClient: CWWiFiClient
    private var interface: CWInterface?

    init(wifiClient: CWWiFiClient) {
        self.wifiClient = wifiClient
        self.interface = wifiClient.interface()
    }

    func getSignalStrength() -> Future<Int, AppCoreWLanError> {
        return Future<Int, AppCoreWLanError> { promise in
            guard let signalStrength = self.interface?.rssiValue() else {
                promise(.failure(.unableToFetchSignalStrength))
                return
            }
            promise(.success(signalStrength))
        }
    }
    func getMbpsRate()-> Future<String, AppCoreWLanError> {
        return Future<String, AppCoreWLanError> { promise in
            guard let transmitRate = self.interface?.transmitRate() else {
                promise(.failure(.unableToFetchSignalStrength))
                return
            }
            promise(.success(transmitRate.toMBps()))
        }
    }
    
    func getHardwareAddress() -> Future<String, AppCoreWLanError> {
        return Future<String, AppCoreWLanError> { promise in
            guard let transmitRate = self.interface?.hardwareAddress() else {
                promise(.failure(.unableToFetchSignalStrength))
                return
            }
            promise(.success(transmitRate))
        }
    }
    
    func getWifiLists() -> Future<[ScaningWifiData], AppCoreWLanError> {
        return Future<[ScaningWifiData], AppCoreWLanError> { promise in
            guard let wifiInterface = self.wifiClient.interface() else {
                promise(.failure(.unableToFetchSignalStrength))
                return
            }
            
            do {
                let networks = try wifiInterface.scanForNetworks(withSSID: nil, includeHidden: false)
                
                let wifiInfoList = networks.compactMap { network -> ScaningWifiData? in
                    guard let ssid = network.ssid else { return nil }
                    return ScaningWifiData(ssid: ssid, rssi: "\(network.rssiValue)")
                }.sorted { Int($0.rssi)! < Int($1.rssi)! }
                
                promise(.success(wifiInfoList))
            } catch {
                promise(.failure(.scanningFailed))
            }
        }
    }

}
