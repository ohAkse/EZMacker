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
}
