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
    func getInterfaceName() -> String
    func getActivePHYMode() -> String
    func getPowerOn() -> Bool
    func getSupportedWLANChannels() -> [Int]
    func getBssid() -> String
    func getNoiseMeasument() -> Int
    func getSecurity() -> String
    func getInterfaceMode() -> String
    func getServiceActive() -> Bool
    var wifiEventPublisher: AnyPublisher<AppWifiEventType, Never> { get }
    
}
public class AppCoreWLanWifiService: AppCoreWLANWifiProvidable {
    public var wifiClient: CWWiFiClient
    private (set) var interface: CWInterface?
    private (set) var wifyKeyChainService: AppWifiKeyChainService
    private (set) var autoConnectService: AppSmartAutoconnectWifiServiceProvidable
    private let wifiEventSubject = PassthroughSubject<AppWifiEventType, Never>()
    public var wifiEventPublisher: AnyPublisher<AppWifiEventType, Never> {
        return wifiEventSubject.eraseToAnyPublisher()
    }
    public init(wifiClient: CWWiFiClient, wifyKeyChainService: AppWifiKeyChainService, autoConnectionService: AppSmartAutoconnectWifiServiceProvidable) {
        self.wifiClient = wifiClient
        self.interface = wifiClient.interface()
        self.wifyKeyChainService = wifyKeyChainService
        self.autoConnectService = autoConnectionService
        configWiFiMonitoring()
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
                return ScaningWifiData(ssid: ssid, rssi: "\(network.rssiValue)", beaconInterval: network.beaconInterval, isSaved: false)
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
                        self.autoConnectService.savePassword(password, for: ssid)
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

// MARK: MoreInfo 추가 정보들
extension AppCoreWLanWifiService {
    public func getNoiseMeasument() -> Int {
        guard let noise = interface?.noiseMeasurement() else {
            Logger.writeLog(.error, message: "노이즈를 가져올 수 없습니다.")
            return -1
        }
        return noise
    }
    
    public func getInterfaceName() -> String {
        guard let interfaceName = interface?.interfaceName else {
            Logger.writeLog(.error, message: "인터페이스 이름을 가져올 수 없습니다.")
            return "Unknown"
        }
        return interfaceName
    }
    
    public func getActivePHYMode() -> String {
        guard let phyMode = interface?.activePHYMode() else {
            Logger.writeLog(.error, message: "PHY 모드를 가져올 수 없습니다.")
            return "Unknown"
        }
        return phyMode.description
    }
    
    public func getPowerOn() -> Bool {
        guard let isPowerOn = interface?.powerOn() else {
            Logger.writeLog(.error, message: "전원 상태를 가져올 수 없습니다.")
            return false
        }
        return isPowerOn
    }
    
    public func getSupportedWLANChannels() -> [Int] {
        guard let wlanChannels = interface?.supportedWLANChannels() else {
            Logger.writeLog(.error, message: "지원되는 WLAN 채널을 가져올 수 없습니다.")
            return []
        }
        let uniqueChannels = Set(wlanChannels.map { $0.channelNumber })
        return uniqueChannels.sorted()
    }
    
    public func getBssid() -> String {
        guard let bssid = interface?.bssid() else {
            Logger.writeLog(.error, message: "BSSID를 가져올 수 없습니다.")
            return "Unknown"
        }
        return bssid
    }
    
    public func getNoiseMeasurement() -> Int {
        guard let noise = interface?.noiseMeasurement() else {
            Logger.writeLog(.error, message: "잡음 측정값을 가져올 수 없습니다.")
            return -1
        }
        return noise
    }
    
    public func getSecurity() -> String {
        guard let security = interface?.security() else {
            Logger.writeLog(.error, message: "보안 정보를 가져올 수 없습니다.")
            return "Unknown"
        }
        return security.description
    }
    
    public func getInterfaceMode() -> String {
        guard let interfaceMode = interface?.interfaceMode() else {
            Logger.writeLog(.error, message: "인터페이스 모드를 가져올 수 없습니다.")
            return "Unknown"
        }
        return interfaceMode.description
    }
    
    public func getServiceActive() -> Bool {
        guard let isActive = interface?.serviceActive() else {
            Logger.writeLog(.error, message: "서비스 활성 상태를 가져올 수 없습니다.")
            return false
        }
        return isActive
    }
    private func configWiFiMonitoring() {
        do {
            try wifiClient.startMonitoringEvent(with: .ssidDidChange)
            try wifiClient.startMonitoringEvent(with: .bssidDidChange)
            try wifiClient.startMonitoringEvent(with: .linkDidChange)
            try wifiClient.startMonitoringEvent(with: .modeDidChange)
            try wifiClient.startMonitoringEvent(with: .powerDidChange)
            try wifiClient.startMonitoringEvent(with: .scanCacheUpdated)
            wifiClient.delegate = self
        } catch {
            Logger.writeLog(.error, message: "Failed to start monitoring Wi-Fi events: \(error.localizedDescription)")
        }
    }
}

extension AppCoreWLanWifiService: CWEventDelegate {
    public func ssidDidChangeForWiFiInterface(withName interfaceName: String) {
        wifiEventSubject.send(.ssidChanged(interfaceName))
    }

    public func bssidDidChangeForWiFiInterface(withName interfaceName: String) {
        wifiEventSubject.send(.bssidChanged(interfaceName))
    }

    public func linkDidChangeForWiFiInterface(withName interfaceName: String) {
        wifiEventSubject.send(.linkChanged(interfaceName))
    }

    public func modeDidChangeForWiFiInterface(withName interfaceName: String) {
        wifiEventSubject.send(.modeChanged(interfaceName))
    }

    public func powerStateDidChangeForWiFiInterface(withName interfaceName: String) {
        wifiEventSubject.send(.powerChanged(interfaceName))
    }

    public func scanCacheUpdatedForWiFiInterface(withName interfaceName: String) {
        wifiEventSubject.send(.scanCacheUpdated(interfaceName))
    }
}
