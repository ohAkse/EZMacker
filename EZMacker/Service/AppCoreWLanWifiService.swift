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
    func getSignalStrength() -> Future<Int, AppCoreWLanStatus>
    func getMbpsRate() -> Future<String, AppCoreWLanStatus>
    func getHardwareAddress() -> Future<String, AppCoreWLanStatus>
    func getWifiLists(attempts: Int ) -> Future<[ScaningWifiData], AppCoreWLanStatus>
    func connectToNetwork(ssid: String, password: String) -> Future<(String, Bool), AppCoreWLanStatus>
    func getCurrentSSID() -> Future<String, AppCoreWLanStatus> 
}

struct AppCoreWLanWifiService: AppCoreWLANWifiProvidable {
    private var wifiClient: CWWiFiClient
    private var interface: CWInterface?
    private var wifyKeyChainService: AppWifiKeyChainService
    private var networkList: Set<CWNetwork> = Set<CWNetwork>()
    init(wifiClient: CWWiFiClient, wifyKeyChainService: AppWifiKeyChainService) {
        self.wifiClient = wifiClient
        self.interface = wifiClient.interface()
        self.wifyKeyChainService = wifyKeyChainService
    }
    
    func getSignalStrength() -> Future<Int, AppCoreWLanStatus> {
        return Future<Int, AppCoreWLanStatus> { promise in
            guard let signalStrength = self.interface?.rssiValue() else {
                promise(.failure(.unableToFetchSignalStrength))
                return
            }
            promise(.success(signalStrength))
        }
    }
    func getMbpsRate() -> Future<String, AppCoreWLanStatus> {
        return Future<String, AppCoreWLanStatus> { promise in
            guard let transmitRate = self.interface?.transmitRate() else {
                promise(.failure(.unableToFetchSignalStrength))
                return
            }
            promise(.success(transmitRate.toMBps()))
        }
    }
    
    func getHardwareAddress() -> Future<String, AppCoreWLanStatus> {
        return Future<String, AppCoreWLanStatus> { promise in
            guard let transmitRate = self.interface?.hardwareAddress() else {
                promise(.failure(.unableToFetchSignalStrength))
                return
            }
            promise(.success(transmitRate))
        }
    }
    
    func getWifiLists(attempts: Int ) -> Future<[ScaningWifiData], AppCoreWLanStatus> {
        return Future<[ScaningWifiData], AppCoreWLanStatus> { promise in
            self.scanWifiLists(attempts: attempts, promise: promise)
        }
    }
    
    private func scanWifiLists(attempts: Int, promise: @escaping (Result<[ScaningWifiData], AppCoreWLanStatus>) -> Void) {
        if attempts < 1 {
            promise(.failure(.scanningFailed))
        }
        
        guard let wifiInterface = wifiClient.interface() else {
            promise(.failure(.unableToFetchSignalStrength))
            return
        }
        
        do {
            let wifiInfoList = try wifiInterface.scanForNetworks(withSSID: nil, includeHidden: false).compactMap { network -> ScaningWifiData? in
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
                Logger.writeLog(.error, message: AppCoreWLanStatus.scanningFailed.errorName)
                promise(.failure(.scanningFailed))
            }
        }
    }
    func connectToNetwork(ssid: String, password: String) -> Future<(String, Bool), AppCoreWLanStatus> {
        return Future { promise in
            guard let interface = self.interface else {
                Logger.writeLog(.error, message: "WiFi 인터페이스를 찾을 수 없음")
                promise(.failure(.unknownError(error: "WiFi 인터페이스를 찾을 수 없음")))
                return
            }
            do {
                let networks = try interface.scanForNetworks(withSSID: nil)
                guard let network = networks.first(where: { $0.ssid == ssid }) else {
                    Logger.writeLog(.error, message: "네트워크를 찾을 수 없음: \(ssid)")
                    promise(.failure(.notFoundSSID))
                    return
                }
                
                DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                    do {
                        Logger.writeLog(.info, message: "네트워크 연결 시도: \(ssid)")
                        try interface.associate(to: network, password: password)
                        promise(.success((ssid, true)))
                    } catch {
                        Logger.writeLog(.error, message: "네트워크 연결 실패: \(error.localizedDescription)")
                        promise(.failure(.unknownError(error: "네트워크 연결 실패: \(error.localizedDescription)")))
                    }
                }
            } catch {
                Logger.writeLog(.error, message: "네트워크 스캔 실패: \(error.localizedDescription)")
                promise(.failure(.scanningFailed))
            }
        }
    }
    func getCurrentSSID() -> Future<String, AppCoreWLanStatus> {
        return Future<String, AppCoreWLanStatus> { promise in
            guard let interface = self.interface else {
                promise(.failure(.unableToFetchSignalStrength))
                return
            }
            
            if let ssid = interface.ssid() {
                promise(.success(ssid))
            } else {
                promise(.success(""))
            }
        }
    }
}
