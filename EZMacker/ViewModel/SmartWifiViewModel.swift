//
//  SmartWifiViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 5/19/24.
//

import Combine
import CoreWLAN
import Foundation
import EZMackerUtilLib
import EZMackerServiceLib
import EZMackerThreadLib

class SmartWifiViewModel<ProvidableType: AppSmartWifiServiceProvidable>: ObservableObject {
    
    deinit {
        Logger.writeLog(.debug, message: "SmartWifiViewModel deinit Called")
        stopWifiTimer()
        stopMonitoring()
    }
    
    private let appSmartWifiService: ProvidableType
    private let systemPreferenceService: SystemPreferenceAccessible
    private let appCoreWLanWifiService: AppCoreWLANWifiProvidable
    private let appStorageSettingService: AppSettingProvidable
    private let appWifiMonitoringService: AppSmartWifiMonitorable
    
    init(appSmartWifiService: ProvidableType, systemPreferenceService: SystemPreferenceAccessible, appCoreWLanWifiService: AppCoreWLANWifiProvidable, appSettingService: AppSettingProvidable, appWifiMonitoringService: AppSmartWifiMonitorable) {
        self.appSmartWifiService = appSmartWifiService
        self.appCoreWLanWifiService = appCoreWLanWifiService
        self.systemPreferenceService = systemPreferenceService
        self.appWifiMonitoringService = appWifiMonitoringService
        self.appStorageSettingService = appSettingService
    }
    // MARK: - Published Variable
    @Published var radioChannelData: RadioChannelData = .init() // ioreg
    @Published var wificonnectData: WifiConnectData = .init() // CoreWLan
    @Published var wifiRequestStatus: AppCoreWLanStatus = .none
    @Published var bestSSid = ""
    @Published var showAlert = false
    @Published var isConnected = false
    
    // MARK: - Service Variable
    private let scanQueue = DispatchQueueFactory.createQueue(for: WifiScanQueueConfiguration(), withPov: false)
    private let timerMax = 10
    private(set) var cancellables = Set<AnyCancellable>()
    private(set) var rrsiTimerCancellable: AnyCancellable?
    private(set) var searchTimerCancellable: AnyCancellable?
    
    func fetchWifiInfo() {
        Publishers.CombineLatest(
            Publishers.CombineLatest3(
                appSmartWifiService.getRegistry(forKey: .IO80211Channel).compactMap { $0 as? Int },
                appSmartWifiService.getRegistry(forKey: .IO80211ChannelBandwidth).compactMap { $0 as? Int },
                appSmartWifiService.getRegistry(forKey: .IO80211ChannelFrequency).compactMap { $0 as? Int }
            ),
            Publishers.CombineLatest3(
                appSmartWifiService.getRegistry(forKey: .IO80211Band).compactMap { $0 as? String },
                appSmartWifiService.getRegistry(forKey: .IO80211Locale).compactMap { $0 as? String },
                appSmartWifiService.getRegistry(forKey: .IOMACAddress).compactMap { $0 as? Data }.map { $0.toHyphenSeparatedMACAddress() }
            )
        )
        .map { channelInfo, otherInfo in
            RadioChannelData(
                channelBandwidth: channelInfo.1,
                channelFrequency: channelInfo.2,
                channel: channelInfo.0,
                band: otherInfo.0,
                locale: otherInfo.1,
                hardwareAddress: otherInfo.2
            )
        }
        .removeDuplicates()
        .assign(to: \.radioChannelData, on: self)
        .store(in: &cancellables)
        
        appCoreWLanWifiService.getCurrentSSID()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.isConnected = false
                        Logger.writeLog(.error, message: error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] in
                    Logger.writeLog(.debug, message: "connectedID > \($0)")
                    self?.wificonnectData.connectedSSid = $0
                    self?.isConnected = true
                }
            )
            .store(in: &cancellables)
    }
  
    func fetchWifiListInfo() {
        appCoreWLanWifiService.getMbpsRate()
            .subscribe(on: DispatchQueue.global(qos: .background))  // 백그라운드에서 실행
            .receive(on: DispatchQueue.main)  // 메인 스레드에서 결과 수신 및 업데이트
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.isConnected = false
                    Logger.writeLog(.error, message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] transmitRate in
                self?.wificonnectData.transmitRate = transmitRate
                self?.isConnected = true
            })
            .store(in: &cancellables)

        // 두 번째 비동기 작업 - Wi-Fi 리스트 조회
        appCoreWLanWifiService.getWifiLists(attempts: 4)
            .subscribe(on: DispatchQueue.global(qos: .background))  // 백그라운드에서 실행
            .receive(on: DispatchQueue.main)  // 메인 스레드에서 결과 수신 및 업데이트
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.wifiRequestStatus = .scanningFailed
                    self?.isConnected = false
                    Logger.writeLog(.error, message: error.description)
                }
            }, receiveValue: { [weak self] wifiLists in
                self?.wificonnectData.scanningWifiList = wifiLists
                self?.isConnected = true
            })
            .store(in: &cancellables)
    }
    
    func getWifiRequestStatus() -> AppCoreWLanStatus {
        return wifiRequestStatus
    }
}

extension SmartWifiViewModel {
    func startWifiTimer() {
        rrsiTimerCancellable = Timer.publish(every: 1, on: .current, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateWifiSignalStrength()
            }
        rrsiTimerCancellable?.store(in: &cancellables)
    }
    
    func stopWifiTimer() {
        rrsiTimerCancellable?.cancel()
        rrsiTimerCancellable = nil
        
        searchTimerCancellable?.cancel()
        searchTimerCancellable = nil
    }
    
    func startMonitoring() {
        appWifiMonitoringService.startMonitoring()
        appWifiMonitoringService.wifiStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                if status.isConnected && status.status == "Satisfied" {
                    self?.wificonnectData.connectedSSid = status.ssid ?? ""
                    self?.wifiRequestStatus = .success
                    self?.isConnected = true
                    self?.fetchWifiInfo()

                } else {
                    self?.wifiRequestStatus = .disconnected
                    self?.isConnected = false
                    self?.radioChannelData.clear()
                }
            }
            .store(in: &cancellables)
    }
    func stopMonitoring() {
        appWifiMonitoringService.stopMonitoring()
    }
}

extension SmartWifiViewModel {
    private func updateWifiSignalStrength() {
        appCoreWLanWifiService.getSignalStrength()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    Logger.writeLog(.error, message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] wifiStrength in
                self?.wificonnectData.strength = wifiStrength
            })
            .store(in: &cancellables)
    }
    
    func connectWifi(ssid: String, password: String) {
        appCoreWLanWifiService.connectToNetwork(ssid: ssid, password: password)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.wifiRequestStatus = error
                    if let isWifiConnected = self?.appCoreWLanWifiService.checkIsConnected(), isWifiConnected {
                         self?.isConnected = true
                     } else {
                         self?.isConnected = false
                     }
                    Logger.writeLog(.error, message: error.localizedDescription)
                    
                }
            }, receiveValue: { [weak self] result in
                let (connectedSSID, isSwitchWifiSuccess) = result
                if isSwitchWifiSuccess {
                    self?.wifiRequestStatus = .success
                    self?.wificonnectData.connectedSSid = connectedSSID
                    self?.fetchWifiInfo()
                    self?.isConnected = true
                    Logger.writeLog(.info, message: "Successfully connected to \(connectedSSID)")
                } else {
                    self?.wifiRequestStatus = .disconnected
                    self?.isConnected = false
                    Logger.writeLog(.error, message: "Failed to connect to \(ssid)")
                }
            })
            .store(in: &cancellables)
    }
    
    func startSearchBestSSid(completion: @escaping () -> Void) {
         guard let bestSSidMode: String = appStorageSettingService.loadConfig(.bestSSIDShowType) else {
             completion()
             return
         }
         let resultShowMode = BestSSIDShowType(rawValue: bestSSidMode)
         var wifirssiList: [String: Set<Int>] = [:]
         
         let searchTimerPublisher = Timer.publish(every: 1, on: RunLoop.main, in: .common)
             .autoconnect()
             .prefix(timerMax)
         
         searchTimerCancellable = searchTimerPublisher
             .flatMap { [weak self] _ -> AnyPublisher<[ScaningWifiData], Never> in
                 guard let self = self else { return Just([]).eraseToAnyPublisher() }
                 
                 return Future<[ScaningWifiData], Never> { [weak self] promise in
                     guard let self = self else { return }
                     self.scanQueue.async {
                         self.appCoreWLanWifiService.getWifiLists(attempts: 1)
                             .catch { error -> AnyPublisher<[ScaningWifiData], Never> in
                                 Logger.writeLog(.error, message: "\(error.localizedDescription)")
                                 return Just([]).eraseToAnyPublisher()
                             }
                             .sink(
                                 receiveCompletion: { _ in },
                                 receiveValue: { value in
                                     promise(.success(value))
                                 }
                             )
                             .store(in: &self.cancellables)
                     }
                 }.eraseToAnyPublisher()
             }
             .sink(
                 receiveCompletion: { [weak self] _ in
                     guard let self = self else { return }
                     DispatchQueue.main.async {
                         let bestSSid = wifirssiList
                             .mapValues { rssiSet in
                                 rssiSet.reduce(0, +) / rssiSet.count
                             }
                             .max(by: { $0.value < $1.value })?
                             .key ?? "와이파이를 찾을 수 없습니다."
                         
                         self.bestSSid = bestSSid
                         if resultShowMode == .alert {
                             self.showAlert = true
                         } else {
                             AppNotificationManager.shared.sendNotification(
                                 title: "알림",
                                 subtitle: "최적의 Wifi : \(bestSSid)"
                             )
                         }
                         completion()
                     }
                 },
                 receiveValue: { wifiList in
                     for wifi in wifiList {
                         if let rssi = Int(wifi.rssi) {
                             wifirssiList[wifi.ssid, default: []].insert(rssi)
                         }
                     }
                 }
             )
         searchTimerCancellable?.store(in: &cancellables)
     }
}
