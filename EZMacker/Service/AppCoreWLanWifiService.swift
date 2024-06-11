//
//  AppCoreWLanWifiService.swift
//  EZMacker
//
//  Created by 박유경 on 5/27/24.
//

import CoreWLAN
import Combine
import Security

protocol AppCoreWLANWifiProvidable {
    func getSignalStrength() -> Future<Int, AppCoreWLanError>
    func getMbpsRate()-> Future<String, AppCoreWLanError>
    func getHardwareAddress()-> Future<String, AppCoreWLanError>
    func getWifiLists(attempts: Int ) -> Future<[ScaningWifiData], AppCoreWLanError>
    func connectToNetwork(ssid: String, password: String, completion: @escaping (Bool, AppCoreWLanError) -> Void)
    func autoConnectToNetwork(ssid: String, completion: @escaping (Bool, AppCoreWLanError) -> Void)
}

class AppCoreWLanWifiService: AppCoreWLANWifiProvidable {
    
    private var wifiClient: CWWiFiClient
    private var interface: CWInterface?
    private var wifyKeyChainService: AppWifiKeyChainService
    private var networkList: Set<CWNetwork> = Set<CWNetwork>()
    init(wifiClient: CWWiFiClient, wifyKeyChainService: AppWifiKeyChainService) {
        self.wifiClient = wifiClient
        self.interface = wifiClient.interface()
        self.wifyKeyChainService = wifyKeyChainService
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
    
    func getWifiLists(attempts: Int ) -> Future<[ScaningWifiData], AppCoreWLanError> {
        return Future<[ScaningWifiData], AppCoreWLanError> { promise in
            self.scanWifiLists(attempts: attempts, promise: promise)
        }
    }
    
    private func scanWifiLists(attempts: Int, promise: @escaping (Result<[ScaningWifiData], AppCoreWLanError>) -> Void) {
        if attempts <= 1 {
            promise(.failure(.scanningFailed))
        }
        
        guard let wifiInterface = wifiClient.interface() else {
            promise(.failure(.unableToFetchSignalStrength))
            return
        }
        
        do {
            networkList = try wifiInterface.scanForNetworks(withSSID: nil, includeHidden: false)
            
            let wifiInfoList = networkList.compactMap { network -> ScaningWifiData? in
                guard let ssid = network.ssid else { return nil }
                return ScaningWifiData(ssid: ssid, rssi: "\(network.rssiValue)")
            }.sorted { Int($0.rssi)! < Int($1.rssi)! }
            
            if wifiInfoList.isEmpty && attempts > 1 {
                self.scanWifiLists(attempts: attempts - 1, promise: promise)
            } else {
                promise(.success(wifiInfoList))
            }
        } catch {
            if attempts > 1 {
                self.scanWifiLists(attempts: attempts - 1, promise: promise)
            } else {
                Logger.writeLog(.error, message: AppCoreWLanError.scanningFailed.errorName)
                promise(.failure(.scanningFailed))
            }
        }
    }
    
    func connectToNetwork(ssid: String, password: String, completion: @escaping (Bool, AppCoreWLanError) -> Void) {
        do {
            guard let network = networkList.first(where: { $0.ssid == ssid }) else {
                 completion(false, .notFoundSSID)
                 return
             }
            Logger.writeLog(.info, message: "\(network.ssid)")
            try interface?.associate(to: network, password: password)
            if (wifyKeyChainService.savePassword(service: "com.myapp.wifi", account: network.ssid!, password: password)) {
                Logger.writeLog(.info, message: "접속성공")
                completion(true, .success)
            } else {
                completion(false, .savePasswordFailed)
                Logger.writeLog(.info, message: "접속실패")
            }
        } catch {
            Logger.writeLog(.error, message: error.localizedDescription)
            completion(false, .unknownError(error: error.localizedDescription))
        }
    }
    
    func autoConnectToNetwork(ssid: String, completion: @escaping (Bool, AppCoreWLanError) -> Void) {
        
    }

}
