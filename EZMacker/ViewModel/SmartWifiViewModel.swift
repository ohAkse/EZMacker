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
    
    // ioreg
    @Published var channelBandwidth = 0
    @Published var channelFrequency = 0
    @Published var channel = 0
    @Published var band = ""
    @Published var locale = ""
    
    // CoreWLan
    @Published var currentWifiStrength = 0
    @Published var currentTransmitRate = ""
    @Published var currentHardwareAddress = ""
    @Published var currentScanningWifiDataList: [ScaningWifiData] = []
    @Published var currentConnectedSSid = ""
    @Published var wifiRequestStatus: AppCoreWLanStatus = .none
    @Published var bestSSid = ""
    @Published var showAlert = false
    
    // private variables
    private var scanResults: [ScaningWifiData] = []
    private var timerCancellable: AnyCancellable?
    private var scanTimerCancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    private let timerMax = 10
    
    func requestWifiInfo() {
        Publishers.Zip3(
            appSmartWifiService.getRegistry(forKey: .IO80211Channel).compactMap { $0 as? Int },
            appSmartWifiService.getRegistry(forKey: .IO80211ChannelBandwidth).compactMap { $0 as? Int },
            appSmartWifiService.getRegistry(forKey: .IO80211ChannelFrequency).compactMap { $0 as? Int }
        )
        .sink { [weak self] channel, channelBandwidth, channelFrequency in
            self?.channel = channel
            self?.channelBandwidth = channelBandwidth
            self?.channelFrequency = channelFrequency
        }
        .store(in: &cancellables)
        
        Publishers.Zip(
            appSmartWifiService.getRegistry(forKey: .IO80211Band).compactMap { $0 as? String },
            appSmartWifiService.getRegistry(forKey: .IO80211Locale).compactMap { $0 as? String }
        )
        .sink { [weak self] band, locale in
            self?.band = band
            self?.locale = locale
        }
        .store(in: &cancellables)
        
        appCoreWLanWifiService.getCurrentSSID()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    Logger.writeLog(.error, message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] currentSSid in
                self?.currentConnectedSSid = currentSSid
            })
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
            }, receiveValue: { [weak self] currentTransmitRate in
                self?.currentTransmitRate = currentTransmitRate
            })
            .store(in: &cancellables)
        
        appCoreWLanWifiService.getHardwareAddress()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    Logger.writeLog(.error, message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] hardwareAddress in
                self?.currentHardwareAddress = hardwareAddress
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
                self?.currentScanningWifiDataList = wifiLists
            })
            .store(in: &cancellables)
    }
    
    func getWifiRequestStatus() -> AppCoreWLanStatus {
        return wifiRequestStatus
    }
}

// 타이머 관련..
extension SmartWifiViewModel {
    func startWifiTimer() {
        timerCancellable = Timer.publish(every: 1, on: .current, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateWifiSignalStrength()
            }
        timerCancellable?.store(in: &cancellables)
    }
    
    func stopWifiTimer() {
        timerCancellable?.cancel()
        scanTimerCancellable?.cancel()
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
            }, receiveValue: { [weak self] currentWifiStrength in
                self?.currentWifiStrength = currentWifiStrength
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
                    self?.currentConnectedSSid = connectedSSID
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
        let currentSSidShowMode = BestSSIDShow(rawValue: bestSSidMode)
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

        scanTimerCancellable = Publishers.Merge(scanPublisher, delayPublisher)
            .collect()
            .sink(receiveCompletion: { [weak self] _ in
                guard let self = self else { return }
                bestSSid = scanResults.max(by: { Int($0.rssi)! < Int($1.rssi)! })?.ssid ?? "No SSID found"
                if currentSSidShowMode == .alert {
                    showAlert = true
                } else {
                    AppNotificationManager.shared.sendNotification(title: "알림", subtitle: "최적의 Wifi : \(self.bestSSid)")
                }
                scanResults.removeAll()
            }, receiveValue: { _ in })
        
        scanTimerCancellable?.store(in: &cancellables)
    }
}
