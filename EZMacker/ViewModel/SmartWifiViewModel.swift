//
//  SmartWifiViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 5/19/24.
//

import Combine
import CoreWLAN
import CoreLocation
class SmartWifiViewModel<ProvidableType: AppSmartWifiServiceProvidable>: ObservableObject {
    
    deinit {
        Logger.writeLog(.debug, message: "SmartWifiViewModel deinit Called")
    }
    private let appSmartWifiService: ProvidableType
    private let systemPreferenceService: SystemPreferenceAccessible
    private let appCoreWLanWifiService: AppCoreWLANWifiProvidable
    
    init(appSmartWifiService: ProvidableType, systemPreferenceService: SystemPreferenceAccessible, appCoreWLanWifiService: AppCoreWLANWifiProvidable) {
        self.appSmartWifiService = appSmartWifiService
        self.appCoreWLanWifiService = appCoreWLanWifiService
        self.systemPreferenceService = systemPreferenceService
    }
    
    //ioreg
    @Published var channelBandwidth = 0
    @Published var channelFrequency = 0
    @Published var channel = 0
    @Published var band = ""
    @Published var ssID = ""
    @Published var locale = ""
    
    //CoreWLan
    @Published var currentWifiStrength = ""
    @Published var currentTransmitRate = ""
    
    private var cancellables = Set<AnyCancellable>()
    func requestWifiInfo() {
        Publishers.Zip3(
            appSmartWifiService.getRegistry(forKey: .IO80211Channel).compactMap { $0 as? Int },
            appSmartWifiService.getRegistry(forKey: .IO80211ChannelBandwidth).compactMap { $0 as? Int },
            appSmartWifiService.getRegistry(forKey: .IO80211ChannelFrequency).compactMap { $0 as? Int }
        )
        .sink { [weak self] channel, channelBandwidth, channelFrequency in
            guard let self = self else { return }
            self.channel = channel
            self.channelBandwidth = channelBandwidth
            self.channelFrequency = channelFrequency
            Logger.writeLog(.info, message: "\(self.channel)")
            Logger.writeLog(.info, message: "\(self.channelBandwidth)")
            Logger.writeLog(.info, message: "\(self.channelFrequency)")
        }
        .store(in: &cancellables)
        
        Publishers.Zip3(
            appSmartWifiService.getRegistry(forKey: .IO80211Band).compactMap { $0 as? String },
            appSmartWifiService.getRegistry(forKey: .IO80211SSID).compactMap { $0 as? String },
            appSmartWifiService.getRegistry(forKey: .IO80211Locale).compactMap { $0 as? String }
        )
        .sink { [weak self] band, ssID, locale in
            guard let self = self else { return }
            self.band = band
            self.ssID = ssID
            self.locale = locale
            
            Logger.writeLog(.info, message: band)
            Logger.writeLog(.info, message: ssID)
            Logger.writeLog(.info, message: locale)
        }
        .store(in: &cancellables)
    }
    func requestCoreWLanWifiInfo() {
        appCoreWLanWifiService.getSignalStrength()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    Logger.writeLog(.error, message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] currentWifiStrength in
                guard let self = self else { return }
                self.currentWifiStrength = currentWifiStrength
                Logger.writeLog(.info, message: currentWifiStrength)
            })
            .store(in: &cancellables)
        
        appCoreWLanWifiService.getMbpsRate()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    Logger.writeLog(.error, message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] currentTransmitRate in
                guard let self = self else { return }
                self.currentTransmitRate = currentTransmitRate
                Logger.writeLog(.info, message: currentTransmitRate)
            })
            .store(in: &cancellables)
    }
}

