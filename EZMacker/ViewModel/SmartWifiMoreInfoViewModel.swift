//
//  SmartWifiMoreInfoViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 10/13/24.
//

import EZMackerServiceLib
import EZMackerUtilLib
import CoreWLAN
import Combine
class SmartWifiMoreInfoViewModel: ObservableObject {
    @Published var radioChannelData: RadioChannelData = .init()
    @Published var wificonnectData: WifiConnectData = .init()
    @Published var wifiRequestStatus: AppCoreWLanStatus = .none
    
    // MARK: 추가 정보(CoreWLan)
    @Published var interfaceName: String = ""
    @Published var activePHYMode: String = ""
    @Published var powerOn: Bool = false
    @Published var supportedWLANChannels: [String] = []
    @Published var bssid: String = ""
    @Published var noiseMeasurement: Int = 0
    @Published var security: String = ""
    @Published var interfaceMode: String = ""
    @Published var serviceActive: Bool = false
    @Published var beaconInterval: String = ""
    @Published var eventType: String = ""
    @Published var eventDetails: String = ""
    
    private let appCoreWLanWifiService: AppCoreWLANWifiProvidable
    private var eventDelegate: CWEventDelegate?
    private var cancellables = Set<AnyCancellable>()
    private var wifiClient: CWWiFiClient?
    init(dataInjector: SmartWifiInjectable, appCoreWLanWifiService: AppCoreWLANWifiProvidable) {
        self.radioChannelData = dataInjector.radioChannelData
        self.wificonnectData = dataInjector.wificonnectData
        self.wifiRequestStatus = dataInjector.wifiRequestStatus
        self.appCoreWLanWifiService = appCoreWLanWifiService
        
        loadCoreWLanMoreInfo()
        configNetworkEventBinding()
        getBeaconInterval()
    }
    
    func loadCoreWLanMoreInfo() {
        self.interfaceName = appCoreWLanWifiService.getInterfaceName()
        self.activePHYMode = appCoreWLanWifiService.getActivePHYMode()
        self.powerOn = appCoreWLanWifiService.getPowerOn()
        self.supportedWLANChannels = appCoreWLanWifiService.getSupportedWLANChannels().map { "\($0)" }
        self.bssid = appCoreWLanWifiService.getBssid()
        self.noiseMeasurement = appCoreWLanWifiService.getNoiseMeasument()
        self.security = appCoreWLanWifiService.getSecurity()
        self.interfaceMode = appCoreWLanWifiService.getInterfaceMode()
        self.serviceActive = appCoreWLanWifiService.getServiceActive()
    }

    private func configNetworkEventBinding() {
        appCoreWLanWifiService.wifiEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.processWifiEvent(event)
            }
            .store(in: &cancellables)
    }
    private func processWifiEvent(_ event: AppWifiEventType) {
           switch event {
           case .ssidChanged(let interfaceName):
               eventType = "SSID 변경"
               eventDetails = "인터페이스 \(interfaceName)의 SSID가 변경 됨"
           case .bssidChanged(let interfaceName):
               eventType = "BSSID 변경"
               eventDetails = "인터페이스 \(interfaceName)의 BSSID가 변경 됨"
           case .linkChanged(let interfaceName):
               eventType = "링크 상태 변경"
               eventDetails = "인터페이스 \(interfaceName)의 링크 상태가 변경 됨"
           case .modeChanged(let interfaceName):
               eventType = "모드 변경"
               eventDetails = "인터페이스 \(interfaceName)의 모드가 변경 됨"
           case .powerChanged(let interfaceName):
               eventType = "전원 상태 변경"
               eventDetails = "인터페이스 \(interfaceName)의 전원 상태 변경 됨"
           case .scanCacheUpdated(let interfaceName):
               eventType = "스캔 캐시 업데이트"
               eventDetails = "인터페이스 \(interfaceName)의 스캔 캐시가 업데이트 됨"
           }
       }
    func getBeaconInterval() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let connectedSSID = self.wificonnectData.connectedSSid
            if let connectedNetwork = self.wificonnectData.scanningWifiList.first(where: { $0.ssid == connectedSSID }),
               let interval = connectedNetwork.beaconInterval {
                Logger.writeLog(.info, message: interval)
                self.beaconInterval = "\(interval) ms"
            } else {
                self.beaconInterval = ""
            }
        }
    }
    deinit {
        Logger.writeLog(.info, message: "SmartWifiMoreInfoViewModel deinit called")
    }
}
