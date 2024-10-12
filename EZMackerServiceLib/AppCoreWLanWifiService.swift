//
//  AppCoreWLanWifiService.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 9/1/24.
//

import CoreWLAN
import Combine
import EZMackerUtilLib

public protocol AppCoreWLANWifiProvidable: AppWiFiClientProvidable {
    func getSignalStrength() -> Future<Int, AppCoreWLanStatus>
    func getMbpsRate() -> Future<String, AppCoreWLanStatus>
    func getHardwareAddress() -> Future<String, AppCoreWLanStatus>
    func getWifiLists(attempts: Int ) -> Future<[ScaningWifiData], AppCoreWLanStatus>
    func connectToNetwork(ssid: String, password: String) -> Future<(String, Bool), AppCoreWLanStatus>
    func getCurrentSSID() -> Future<String, AppCoreWLanStatus>
    func checkIsConnected() -> Bool
}

public struct AppCoreWLanWifiService: AppCoreWLANWifiProvidable {
    public var wifiClient: CWWiFiClient
    private(set) var interface: CWInterface?
    private(set) var wifyKeyChainService: AppWifiKeyChainService
    private(set) var autoConnectService: AppSmartAutoconnectWifiServiceProvidable
    private(set) var networkList: Set<CWNetwork> = Set<CWNetwork>()
    
    public init(wifiClient: CWWiFiClient, wifyKeyChainService: AppWifiKeyChainService, autoConnectionService: AppSmartAutoconnectWifiServiceProvidable) {
        self.wifiClient = wifiClient
        self.interface = wifiClient.interface()
        self.wifyKeyChainService = wifyKeyChainService
        self.autoConnectService = autoConnectionService
    }
    
    public func getSignalStrength() -> Future<Int, AppCoreWLanStatus> {
        return Future<Int, AppCoreWLanStatus> { promise in
            guard let signalStrength = self.interface?.rssiValue() else {
                promise(.failure(.unableToFetchSignalStrength))
                return
            }
            promise(.success(signalStrength))
        }
    }
    public func getMbpsRate() -> Future<String, AppCoreWLanStatus> {
        return Future<String, AppCoreWLanStatus> { promise in
            guard let transmitRate = self.interface?.transmitRate() else {
                promise(.failure(.unableToFetchSignalStrength))
                return
            }
            promise(.success(transmitRate.toMBps()))
        }
    }
    
    public func getHardwareAddress() -> Future<String, AppCoreWLanStatus> {
        return Future<String, AppCoreWLanStatus> { promise in
            guard let transmitRate = self.interface?.hardwareAddress() else {
                promise(.failure(.unableToFetchSignalStrength))
                return
            }
            promise(.success(transmitRate))
        }
    }
    
    public func getWifiLists(attempts: Int ) -> Future<[ScaningWifiData], AppCoreWLanStatus> {
        return Future<[ScaningWifiData], AppCoreWLanStatus> { promise in
            self.scanWifiLists(attempts: attempts, promise: promise)
        }
    }
    
    private func scanWifiLists(attempts: Int, promise: @escaping (Result<[ScaningWifiData], AppCoreWLanStatus>) -> Void) {
        if attempts < 1 {
            Logger.writeLog(.error, message: "retry 숫자 초과..")
            promise(.failure(.scanningFailed))
        }
        
        guard let wifiInterface = wifiClient.interface() else {
            promise(.failure(.unableToFetchSignalStrength))
            return
        }
        
        do {
            let wifiInfoList = try wifiInterface.scanForNetworks(withSSID: nil, includeHidden: false).compactMap { network -> ScaningWifiData? in
                guard let ssid = network.ssid else { return nil }
                return ScaningWifiData(ssid: ssid, rssi: "\(network.rssiValue)", isSaved: false)
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
                Logger.writeLog(.error, message: AppCoreWLanStatus.scanningFailed.description)
                promise(.failure(.scanningFailed))
            }
        }
    }
    public func connectToNetwork(ssid: String, password: String) -> Future<(String, Bool), AppCoreWLanStatus> {
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
                        autoConnectService.savePassword(password, for: ssid)
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
    public func getCurrentSSID() -> Future<String, AppCoreWLanStatus> {
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
    public func checkIsConnected() -> Bool {
        guard let interface = self.interface else {
            return false
        }
        if interface.powerOn() {
            return true
        } else {
            return false
        }
    }
}
