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
import Foundation
class SmartWifiMoreInfoViewModel: ObservableObject {
    
    // MARK: CoreWLAN + DetailInfo + Event
    @Published var radioChannelData: RadioChannelData = .init()
    @Published var wificonnectData: WifiConnectData = .init()
    @Published var wifiRequestStatus: AppCoreWLanStatus = .none
    @Published var beaconInterval = ""
    @Published var eventType: String = ""
    @Published var eventDetails: String = ""
    // MARK: Command 추가정보
    @Published var ipv4Address: String = ""
    @Published var ipv6Address: String = ""
    @Published var subnetMask: String = ""
    @Published var interfaces: [NetworkInterfaceData] = []
    @Published var interfaceMulticastInfo: [String: Bool] = [:]
    @Published var multicastTraffic: [String] = []
    
    @Published var commandList: [String] = [
        "sudo tcpdump -i en0 'multicast' (en0 인터페이스에서 멀티캐스트 패킷을 캡처)",
        "ifconfig | grep multicast (네트워크 인터페이스에서 멀티캐스트 관련 정보 확인)",
        "netstat -g (현재 그룹 멀티캐스트 테이블 확인)",
        "lsof -i UDP:5353 (5353 UDP 포트를 사용하는 프로세스 확인, mDNS)",
        "dns-sd -B _services._dns-sd._udp (mDNS를 통해 네트워크 상의 서비스 브라우징)",
        "sudo tcpdump -i en0 port 5353 (en0 인터페이스에서 5353 포트 트래픽 캡처, mDNS 트래픽)",
        "sudo nmap -sU -p 5353 localhost (로컬 호스트에서 5353 UDP 포트 스캔, mDNS 포트)",
        "netstat -an | grep LISTEN (현재 열려있는 포트와 해당 포트의 상태 확인)",
        "avahi-browse -a (Linux에서 mDNS 및 DNS-SD 서비스 검색 및 확인)",
        "ping 224.0.0.251 (mDNS 멀티캐스트 주소로 핑 보내기, 정상적으로 응답이 오는지 확인)",
        "sudo ip maddr (네트워크 인터페이스에서 등록된 멀티캐스트 주소 목록 확인)",
        "sudo sysctl -w net.inet.udp.checksum=1 (UDP 체크섬 활성화, 멀티캐스트 체크섬 문제 확인)",
        "arp -a (현재 ARP 테이블에서 로컬 네트워크의 호스트들 확인)",
        "dig -p 5353 @224.0.0.251 _services._dns-sd._udp.local PTR (mDNS 쿼리를 수동으로 전송하여 응답 확인)",
        "sudo tcpdump -vvv -i en0 udp port 5353 (mDNS 패킷의 세부 정보를 자세하게 캡처)",
        "dns-sd -L 'Service Name' _service-type._tcp.local. (특정 서비스의 세부 정보 조회)",
        "dns-sd -Q 'Service Name'._service-type._tcp.local. (특정 서비스의 DNS 레코드 쿼리)",
        "mdns-scan (네트워크에서 mDNS 서비스 스캔, 설치 필요)",
        "avahi-resolve -a [IP 주소] (IP 주소를 호스트 이름으로 역방향 확인, Linux)",
        "avahi-resolve -n [호스트 이름] (호스트 이름을 IP 주소로 확인, Linux)",
        "sudo tcpdump -i en0 'udp port 5353 or igmp' (mDNS 및 IGMP 트래픽 캡처)",
        "sudo nmap -p 5353 --script=dns-service-discovery 192.168.1.0/24 (네트워크 범위 내 mDNS 서비스 검색)",
        "dns-sd -E (mDNS 이벤트 모니터링)",
        "dns-sd -F (mDNS 도메인 열거)",
        "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder (DNS 및 mDNS 캐시 초기화, macOS)",
        "sudo systemd-resolve --flush-caches (DNS 캐시 초기화, Linux)",
        "scutil --dns (DNS 설정 확인, macOS)",
        "cat /etc/nsswitch.conf | grep hosts (이름 확인 순서 확인, Linux)",
        "sudo tcpdump -i en0 'udp port 5353 and (udp[8] & 0x80 = 0)' (mDNS 쿼리만 캡처)",
        "sudo tcpdump -i en0 'udp port 5353 and (udp[8] & 0x80 = 0x80)' (mDNS 응답만 캡처)"
    ]

    private var cancellables = Set<AnyCancellable>()
    private let appCoreWLanWifiService: AppCoreWLANWifiProvidable
    private var eventDelegate: CWEventDelegate?
    
    init(dataInjector: SmartWifiInjectable, appCoreWLanWifiService: AppCoreWLANWifiProvidable) {
        self.radioChannelData = dataInjector.radioChannelData
        self.wificonnectData = dataInjector.wificonnectData
        self.appCoreWLanWifiService = appCoreWLanWifiService
        
        loadCoreWLanMoreInfo()
        loadNetworkInfo()
        loadMulticastInfo()
        configNetworkEventBinding()
        getBeaconInterval()
    }
    
    func loadCoreWLanMoreInfo() {
        wificonnectData.interfaceName = appCoreWLanWifiService.getInterfaceName()
        wificonnectData.activePHYMode = appCoreWLanWifiService.getActivePHYMode()
        wificonnectData.powerOn = appCoreWLanWifiService.getPowerOn()
        wificonnectData.supportedWLANChannels = appCoreWLanWifiService.getSupportedWLANChannels().map { "\($0)" }
        wificonnectData.bssid = appCoreWLanWifiService.getBssid()
        wificonnectData.noiseMeasurement = appCoreWLanWifiService.getNoiseMeasument()
        wificonnectData.security = appCoreWLanWifiService.getSecurity()
        wificonnectData.interfaceMode = appCoreWLanWifiService.getInterfaceMode()
        wificonnectData.serviceActive = appCoreWLanWifiService.getServiceActive()
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
    func loadNetworkInfo() {
        let interfaces = ["en0", "en1"]
        for interface in interfaces {
            CommandToolRunner.runCommand(command: MDInterfaceInfoCommand.ifconfig(interface: interface)) { [weak self] result in
                DispatchQueue.main.async {
                    if let result = result {
                        let info = MDInterfaceInfoCommand.parse(result, for: interface)
                        self?.interfaces.append(info)
                    }
                }
            }
        }
    }
    private func loadMulticastInfo() {
        let interfaces = getAllNetworkInterfaces()
        for interface in interfaces {
            CommandToolRunner.runCommand(command: MDMulticastCommand.checkInterface(interface: interface)) { [weak self] result in
                DispatchQueue.main.async {
                    self?.interfaceMulticastInfo[interface] = result?.lowercased().contains("multicast") ?? false
                }
            }
        }
    }
    
    private func getAllNetworkInterfaces() -> [String] {
        var interfaces: [String] = []
        
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return interfaces }
        guard let firstAddr = ifaddr else { return interfaces }
        
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = String(cString: ptr.pointee.ifa_name)
            if !interfaces.contains(interface) {
                interfaces.append(interface)
            }
        }
        
        freeifaddrs(ifaddr)
        return interfaces
    }
    
    deinit {
        Logger.writeLog(.info, message: "SmartWifiViewModel deinit called")
    }
}
