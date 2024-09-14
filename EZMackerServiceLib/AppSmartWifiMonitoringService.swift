//
//  AppSmartWifiMonitoringService.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 9/4/24.
//

import Network
import CoreWLAN
import Combine
import EZMackerThreadLib

public protocol AppSmartWifiMonitorable: AppWiFiClientProvidable {
    func startMonitoring()
    func stopMonitoring()
    func getSSID() -> String?
    var wifiStatusPublisher: AnyPublisher<(isConnected: Bool, ssid: String?, status: String), Never> { get }
}

public class AppSmartWifiMonitoringService: AppSmartWifiMonitorable {
    private let monitor: NWPathMonitor
    private let wifiMonitoringQueue = DispatchQueueBuilder().createQueue(for: .wifiMonitoring)
    private let statusSubject = PassthroughSubject<(isConnected: Bool, ssid: String?, status: String), Never>()
    public  var wifiClient: CWWiFiClient
    
    public var wifiStatusPublisher: AnyPublisher<(isConnected: Bool, ssid: String?, status: String), Never> {
        return statusSubject
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .removeDuplicates { $0.isConnected == $1.isConnected && $0.ssid == $1.ssid && $0.status == $1.status }
            .eraseToAnyPublisher()
    }
    
    public init(wifiClient: CWWiFiClient) {
        self.wifiClient = wifiClient
        self.monitor = NWPathMonitor(requiredInterfaceType: .wifi)
        self.monitor.pathUpdateHandler = { [weak self] path in
            self?.makePathUpdate(path)
        }
    }

    public func startMonitoring() {
        monitor.start(queue: wifiMonitoringQueue)
    }

    public func stopMonitoring() {
        monitor.cancel()
    }

    public func getSSID() -> String? {
        guard let interface = wifiClient.interface() else {
            return nil
        }
        return interface.ssid()
    }

    private func makePathUpdate(_ path: NWPath) {
        let ssid = getSSID()
        let isConnected = path.status == .satisfied
        let status: String

        switch path.status {
        case .satisfied:
            status = "Satisfied"
        case .unsatisfied:
            status = "Unsatisfied"
        case .requiresConnection:
            status = "Requires Connection"
        @unknown default:
            status = "Unknown"
        }

        statusSubject.send((isConnected: isConnected, ssid: ssid, status: status))
    }
}
