//
//  SmartWifiViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 5/19/24.
//

import Combine
import CoreWLAN
import Foundation

class SmartWifiViewModel<ProvidableType: AppSmartWifiServiceProvidable>: ObservableObject {
    
    deinit {
        Logger.writeLog(.debug, message: "SmartWifiViewModel deinit Called")
        stopWifiTimer()
    }
    
    private let appSmartWifiService: ProvidableType
    private let systemPreferenceService: SystemPreferenceAccessible
    private let appCoreWLanWifiService: AppCoreWLANWifiProvidable
    private let appSettingService: AppSmartSettingProvidable
    
    init(appSmartWifiService: ProvidableType, systemPreferenceService: SystemPreferenceAccessible, appCoreWLanWifiService: AppCoreWLANWifiProvidable, appSettingService: AppSmartSettingProvidable) {
        self.appSmartWifiService = appSmartWifiService
        self.appCoreWLanWifiService = appCoreWLanWifiService
        self.systemPreferenceService = systemPreferenceService
        self.appSettingService = appSettingService
    }
    // DATA
    @Published var radioChannelData: RadioChannelData = .init() // ioreg
    @Published var wificonnectData: WifiConnectData = .init() // CoreWLan
    
    // UI
    @Published var wifiRequestStatus: AppCoreWLanStatus = .none
    @Published var bestSSid = ""
    @Published var showAlert = false
    @Published var isConnecting = false
    
    // Private Variables
    private let scanQueue =  DispatchQueue(label: "ezMacker.com", attributes: .concurrent)
    private var scanResults: [ScaningWifiData] = []
    private var cancellables = Set<AnyCancellable>()
    private var rrsiTimerCancellable: AnyCancellable?
    private var searchTimerCancellable: AnyCancellable?
    private let timerMax = 10
    
    func requestWifiInfo() {
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
        .assign(to: \.radioChannelData, on: self)
        .store(in: &cancellables)

        // TODO: 가끔 connectedID가 Emptry로 나오는데 API문제? 코드문제?
        appCoreWLanWifiService.getCurrentSSID()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        Logger.writeLog(.error, message: error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] in
                    Logger.writeLog(.debug, message: "connectedID > \($0)")
                    self?.wificonnectData.connectedSSid = $0
                }
            )
            .store(in: &cancellables)
    }
    
    func requestCoreWLanWifiInfo() async {
        appCoreWLanWifiService.getMbpsRate()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    Logger.writeLog(.error, message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] transmitRate in
                self?.wificonnectData.transmitRate = transmitRate
            })
            .store(in: &cancellables)
        
        appCoreWLanWifiService.getWifiLists(attempts: 4)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.wifiRequestStatus = .scanningFailed
                    Logger.writeLog(.error, message: error.errorName)
                }
            }, receiveValue: { [weak self] wifiLists in
                self?.wificonnectData.scanningWifiList = wifiLists
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
    
    func connectWifi(ssid: String, password: String) async {
        appCoreWLanWifiService.connectToNetwork(ssid: ssid, password: password)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.wifiRequestStatus = error
                    Logger.writeLog(.error, message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] result in
                let (connectedSSID, isSwitchWifiSuccess) = result
                if isSwitchWifiSuccess {
                    self?.wifiRequestStatus = .success
                    self?.wificonnectData.connectedSSid = connectedSSID
                    Logger.writeLog(.info, message: "Successfully connected to \(connectedSSID)")
                } else {
                    self?.wifiRequestStatus = .notFoundSSID
                    Logger.writeLog(.error, message: "Failed to connect to \(ssid)")
                }
            })
            .store(in: &cancellables)
    }
    func startSearchBestSSid() {
        guard let bestSSidMode: String = appSettingService.loadConfig(.bestSSidShowMode) else { return }
        let resultShowMode = BestSSIDShow(rawValue: bestSSidMode)
        var wifirssiList: [String: Set<Int>] = [:]
        
        let searchTimerPublisher = Timer.publish(every: 1, on: RunLoop.main, in: .common)
            .autoconnect()
            .prefix(timerMax)
        
        searchTimerCancellable = searchTimerPublisher
            .flatMap { [weak self] _ -> AnyPublisher<[ScaningWifiData], Never> in
                guard let self = self else { return Just([]).eraseToAnyPublisher() }
                
                return Future<[ScaningWifiData], Never> { promise in
                    self.scanQueue.async {
                        self.appCoreWLanWifiService.getWifiLists(attempts: 1)
                            .catch { error -> AnyPublisher<[ScaningWifiData], Never> in
                                Logger.writeLog(.error, message: "\(error.localizedDescription)")
                                return Just([]).eraseToAnyPublisher()
                            }
                            .sink(
                                receiveCompletion: { _ in },
                                receiveValue: { value in promise(.success(value)) }
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
