//
//  AppCoreWLanWifiService.swift
//  EZMacker
//
//  Created by 박유경 on 5/27/24.
//

import CoreWLAN
import Combine
protocol AppCoreWLANWifiProvidable {
    func getSignalStrength() -> Future<String, AppCoreWLanError>
    func getMbpsRate()-> Future<String, AppCoreWLanError>
}

class AppCoreWLanWifiService: AppCoreWLANWifiProvidable {

    private var wifiClient: CWWiFiClient
    private var interface: CWInterface?

    init(wifiClient: CWWiFiClient) {
        self.wifiClient = wifiClient
        self.interface = wifiClient.interface()
    }

    func getSignalStrength() -> Future<String, AppCoreWLanError> {
        return Future<String, AppCoreWLanError> { promise in
            guard let signalStrength = self.interface?.rssiValue() else {
                promise(.failure(.unableToFetchSignalStrength))
                return
            }
            let description: String
            switch signalStrength {
            case -30..<0:
                description = "매우 강한 신호"
            case -67..<(-30):
                description = "강한 신호"
            case -70..<(-67):
                description = "양호한 신호"
            case -80..<(-70):
                description = "약한 신호"
            case ..<(-80):
                description = "매우 약한 신호"
            default:
                description = "알 수 없는 신호 강도"
            }
            promise(.success(description))
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
