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
    
    @Published var radioChannelData: RadioChannelData = .init() // ioreg
    @Published var wificonnectData: WifiConnectData = .init() // CoreWLan
    
    @Published var wifiRequestStatus: AppCoreWLanStatus = .none
    @Published var bestSSid = ""
    @Published var showAlert = false
    
    // private variables
    private var scanResults: [ScaningWifiData] = []
    private var wifiTimerCancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    private let timerMax = 10
    
    func requestWifiInfo() {
        let channel = appSmartWifiService.getRegistry(forKey: .IO80211Channel).compactMap { $0 as? Int }
        let bandwidth = appSmartWifiService.getRegistry(forKey: .IO80211ChannelBandwidth).compactMap { $0 as? Int }
        let frequency = appSmartWifiService.getRegistry(forKey: .IO80211ChannelFrequency).compactMap { $0 as? Int }
        let band = appSmartWifiService.getRegistry(forKey: .IO80211Band).compactMap { $0 as? String }
        let locale = appSmartWifiService.getRegistry(forKey: .IO80211Locale).compactMap { $0 as? String }
        let macAddress = appSmartWifiService.getRegistry(forKey: .IOMACAddress)
             .compactMap { $0 as? Data }
             .map { $0.toHyphenSeparatedMACAddress() }

        Publishers.CombineLatest(
            Publishers.CombineLatest3(bandwidth, frequency, channel),
            Publishers.CombineLatest3(band, locale, macAddress)
        )
        .map { (channelInfo, bandInfo) in
            RadioChannelData(
                channelBandwidth: channelInfo.0,
                channelFrequency: channelInfo.1,
                channel: channelInfo.2,
                band: bandInfo.0,
                locale: bandInfo.1,
                hardwareAddress: bandInfo.2
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
        wifiTimerCancellable = Timer.publish(every: 1, on: .current, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateWifiSignalStrength()
            }
        
        wifiTimerCancellable?.store(in: &cancellables)
    }
    
    func stopWifiTimer() {
        wifiTimerCancellable?.cancel()
        wifiTimerCancellable = nil
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
        guard let bestSSidMode: String = appSettingService.loadConfig(.bestSSidShowMode)  else {return}
        let SSidShowMode = BestSSIDShow(rawValue: bestSSidMode)
        scanResults.removeAll()
        showAlert = false
        
        let timerPublisher = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .prefix(timerMax)
            .eraseToAnyPublisher()

        let scanPublisher = timerPublisher
            .flatMap { [weak self] _ -> AnyPublisher<[ScaningWifiData], Never> in
                guard let self = self else { return Just([]).eraseToAnyPublisher() }
                return self.appCoreWLanWifiService.getWifiLists(attempts: 1)
                    .catch { _ in Just([]) }
                    .setFailureType(to: Never.self)
                    .eraseToAnyPublisher()
            }
            .handleEvents(receiveOutput: { [weak self] wifiLists in
                guard let self = self else { return }
                self.scanResults.append(contentsOf: wifiLists)
            })
            .eraseToAnyPublisher()
        
        let delayPublisher = Just(())
            .delay(for: .seconds(timerMax), scheduler: DispatchQueue.main)
            .flatMap { _ in Empty<[ScaningWifiData], Never>() }
            .eraseToAnyPublisher()

        wifiTimerCancellable = Publishers.Merge(scanPublisher, delayPublisher)
            .collect()
            .sink(receiveCompletion: { [weak self] _ in
                guard let self = self else { return }
                bestSSid = scanResults.max(by: { Int($0.rssi)! < Int($1.rssi)! })?.ssid ?? "No SSID found"
                if SSidShowMode == .alert {
                    showAlert = true
                } else {
                    AppNotificationManager.shared.sendNotification(title: "알림", subtitle: "최적의 Wifi : \(self.bestSSid)")
                }
                scanResults.removeAll()
            }, receiveValue: { _ in })
        
        wifiTimerCancellable?.store(in: &cancellables)
    }
}
