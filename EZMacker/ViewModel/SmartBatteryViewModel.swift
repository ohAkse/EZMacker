//
//  SmartBatteryViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//
import Combine
import SwiftUI

struct ChargeData: Identifiable {
    var id = UUID()
    var vacVoltageLimit: Int
    var chargingCurrent: CGFloat
    var timeChargingThermallyLimited: Int
    var chargerStatus: Data
    var chargingVoltage: CGFloat
    var chargerInhibitReason: Int
    var chargerID: Int
    var notChargingReason: Int
}

class SmartBatteryViewModel<ProvidableType: AppSmartBatteryRegistryProvidable>: ObservableObject {
    
    deinit {
        Logger.writeLog(.info, message: "SmartBatteryViewModel deinit Called")
    }
    //배터리 관련 설정값들
    @Published var isCharging = false
    @Published var temperature = 0
    @Published var currentBatteryCapacity = 0.0
    
    @Published var remainingTime = 0
    @Published var chargingTime = 0
    @Published var cycleCount = 0
    @Published var maxCapacity = 0
    @Published var healthState = ""
    @Published var batteryMaxCapacity = 0
    @Published var designedCapacity = 0
    @Published var batteryCellDisconnectCount = 0
    @Published var chargeData: [ChargeData] = []
    
    //어댑터 관련 설정값들
    @Published var adapterInfo: [AdapterDetails]?
    @Published var isAdapterConnected = false
    @Published var adapterConnectionSuccess :AdapterConnectStatus = .none
    
    //일반 설정값들
    private var systemPreferenceService: SystemPreferenceAccessible
    private var appSmartBatteryService: ProvidableType
    private var timer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    init(appSmartBatteryService: ProvidableType, systemPreferenceService: SystemPreferenceAccessible) {
        self.appSmartBatteryService = appSmartBatteryService
        self.systemPreferenceService =  systemPreferenceService
        
        
    }
    //충전기 Off시 배터리 정보만 나타내는 함수
    private func requestBatteryInfo() {
         Publishers.CombineLatest(
            appSmartBatteryService.getPowerSourceValue(for: .batteryHealth, defaultValue: ""),
            appSmartBatteryService.getRegistry(forKey: .BatteryCellDisconnectCount).compactMap { $0 as? Int }
        )
        .sink { [weak self] healthState, batteryCellDisconnectCount in
            guard let self = self else { return }
            if self.healthState != healthState {
                self.healthState = healthState
            }
            if self.batteryCellDisconnectCount != batteryCellDisconnectCount {
                self.batteryCellDisconnectCount = batteryCellDisconnectCount
            }
        }
        .store(in: &cancellables)    }
}
extension SmartBatteryViewModel {
    func startConnectTimer() {
        
        timer = Timer.publish(every: 3, on: .current, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkAdapterConnectionStatus()
            }
        timer?.store(in: &cancellables)
    }
    func stopConnectTimer() {
        timer?.cancel()
        timer = nil
        cancellables.removeAll()
    }
    //처음 로드되면 밑에 할당되는 배터리 정보
    func requestStaticBatteryInfo() {
        Publishers.CombineLatest4(
            appSmartBatteryService.getRegistry(forKey: .CycleCount).compactMap { $0 as? Int },
            appSmartBatteryService.getRegistry(forKey: .Temperature).compactMap { $0 as? Int },
            appSmartBatteryService.getRegistry(forKey: .DesignCapacity).compactMap { $0 as? Int },
            appSmartBatteryService.getRegistry(forKey: .AppleRawMaxCapacity).compactMap { $0 as? Int }
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] cycleCount, temperature, designedCapacity, batteryMaxCapacity in
            guard let self = self else { return }
            if self.cycleCount != cycleCount {
                self.cycleCount = cycleCount
            }
            if self.temperature != temperature {
                self.temperature = temperature
            }
            if self.designedCapacity != designedCapacity {
                self.designedCapacity = designedCapacity
            }
            if self.batteryMaxCapacity != batteryMaxCapacity {
                self.batteryMaxCapacity = batteryMaxCapacity
            }
        }
        .store(in: &cancellables)

    }
    //어댑터 연결상태에 따라 정보가 변하는 함수
    func checkAdapterConnectionStatus() {
        
        appSmartBatteryService.getRegistry(forKey: .ChargerData)
              .subscribe(on: DispatchQueue.global())
              .compactMap { $0 as? [String: Any] }
              .compactMap { dict -> ChargeData? in
                  guard let vacVoltageLimit = dict["VacVoltageLimit"] as? Int,
                        let chargingCurrent = dict["ChargingCurrent"] as? CGFloat,
                        let timeChargingThermallyLimited = dict["TimeChargingThermallyLimited"] as? Int,
                        let chargerStatus = dict["ChargerStatus"] as? Data,
                        let chargingVoltage = dict["ChargingVoltage"] as? CGFloat,
                        let chargerInhibitReason = dict["ChargerInhibitReason"] as? Int,
                        let chargerID = dict["ChargerID"] as? Int,
                        let notChargingReason = dict["NotChargingReason"] as? Int else {
                      return nil
                  }
                  return ChargeData(vacVoltageLimit: vacVoltageLimit,
                                    chargingCurrent: 800,
                                    timeChargingThermallyLimited: timeChargingThermallyLimited,
                                    chargerStatus: chargerStatus,
                                    chargingVoltage: chargingVoltage,
                                    chargerInhibitReason: chargerInhibitReason,
                                    chargerID: chargerID,
                                    notChargingReason: notChargingReason)
              }
              .receive(on: DispatchQueue.main)
              .sink { [weak self] chargeData in
                  guard let self = self else { return }
                  self.chargeData.append(chargeData)
                  if self.chargeData.count > 10 {
                      self.chargeData.removeFirst()
                  }
              }
              .store(in: &cancellables)
        
        Publishers.Zip(
            appSmartBatteryService.getRegistry(forKey: .TimeRemaining).compactMap { $0 as? Int },
            appSmartBatteryService.getPowerSourceValue(for: .chargingTime, defaultValue: 0)
        )
        .sink { [weak self] remainingTime, chargingTime in
            guard let self = self else { return }
            self.remainingTime = remainingTime
            self.chargingTime = chargingTime
//            Logger.writeLog(.info, message: "charging -> \(chargingTime)")
//            Logger.writeLog(.info, message: "remainingTime -> \(remainingTime)")
        }
        .store(in: &cancellables)
    
        
        appSmartBatteryService.getRegistry(forKey: .IsCharging)
             .subscribe(on: DispatchQueue.global())
             .compactMap { $0 as? Bool }
             .receive(on: DispatchQueue.main)
             .sink { [weak self] isCharging in
                 guard let self = self else { return }
                  if self.isCharging != isCharging {
                      self.isCharging = isCharging
                  }
             }
             .store(in: &cancellables)
        appSmartBatteryService.getRegistry(forKey: .CurrentCapacity)
             .subscribe(on: DispatchQueue.global())
             .compactMap { $0 as? Int }
             .map { Double($0) / 100.0 }
             .receive(on: DispatchQueue.main)
             .sink { [weak self] currentCapacity in
                 guard let self = self else { return }
                 if self.currentBatteryCapacity != currentCapacity {
                     self.currentBatteryCapacity = currentCapacity
                 }
             }
             .store(in: &cancellables)
        
        appSmartBatteryService.getRegistry(forKey: .AppleRawAdapterDetails)
            .subscribe(on: DispatchQueue.global())
            .tryMap { value -> Data in
                guard let value = value else {
                    throw AdapterConnectStatus.dataNotFound
                }
                return try JSONSerialization.data(withJSONObject: value, options: [])
            }
            .decode(type: [AdapterDetails].self, decoder: JSONDecoder())
            .mapError { error -> AdapterConnectStatus in
                switch error {
                case is DecodingError:
                    return .decodingFailed
                default:
                    return .unknown(error)
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(_) = completion {
                        self.adapterConnectionSuccess = .decodingFailed
                    }
                },
                receiveValue: { [weak self] adapterDetails in
                    guard let self = self else {return }
                    let adapterConnected = adapterDetails.count == 0 ?  false : true
                    if adapterConnected {
                    } else {
                        requestBatteryInfo()
                    }
                    
                    if isAdapterConnected != adapterConnected {
                        isAdapterConnected = adapterConnected
                    }
                    adapterInfo = adapterDetails
                    adapterConnectionSuccess = .processing
                }
            )
            .store(in: &cancellables)
    }
    func openSettingWindow(settingPath: String) {
        systemPreferenceService.openSystemPreferences(systemPath: settingPath)
    }
}
struct ProcessInfo {
    let pid: Int32
    let name: String
    let cpuUsage: Double
}


extension SmartBatteryViewModel {
    func runShellCommand(_ command: String) -> String? {
        let process = Process()
        process.launchPath = "/bin/bash"
        process.arguments = ["-c", command]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        let fileHandle = pipe.fileHandleForReading
        process.launch()

        let data = fileHandle.readDataToEndOfFile()
        process.waitUntilExit()

        let output = String(data: data, encoding: .utf8)
        return output
    }

    // Function to get the list of processes with high CPU usage
    func getHighCpuProcesses() -> [(pid: String, name: String, cpu: String)] {
        guard let output = runShellCommand("ps aux | sort -nrk 3 | head -10") else {
            return []
        }

        var processes: [(pid: String, name: String, cpu: String)] = []
        let lines = output.split(separator: "\n").dropFirst()

        for line in lines {
            let columns = line.split(separator: " ", omittingEmptySubsequences: true)
            if columns.count >= 11 {
                let pid = String(columns[1])
                let cpu = String(columns[2])
                let name = columns[10...].joined(separator: " ")
                processes.append((pid: pid, name: name, cpu: cpu))
            }
        }

        return processes
    }

    func hostCPULoadInfo() -> host_cpu_load_info? {
        let HOST_CPU_LOAD_INFO_COUNT = MemoryLayout<host_cpu_load_info>.stride/MemoryLayout<integer_t>.stride
        var size = mach_msg_type_number_t(HOST_CPU_LOAD_INFO_COUNT)
        var cpuLoadInfo = host_cpu_load_info()

        let result = withUnsafeMutablePointer(to: &cpuLoadInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: HOST_CPU_LOAD_INFO_COUNT) {
                host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &size)
            }
        }
        if result != KERN_SUCCESS{
            print("Error  - \(#file): \(#function) - kern_result_t = \(result)")
            return nil
        }
        return cpuLoadInfo
    }


}
class MyCpuUsage {
    var cpuInfo: processor_info_array_t!
    var prevCpuInfo: processor_info_array_t?
    var numCpuInfo: mach_msg_type_number_t = 0
    var numPrevCpuInfo: mach_msg_type_number_t = 0
    let numCPUs: uint
    let CPUUsageLock = NSLock()

    init() {
        // obtaining numCPUs
        let mibKeys: [Int32] = [ CTL_HW, HW_NCPU ]
        var numCPUs: uint = 0
        mibKeys.withUnsafeBufferPointer() { mib in
            var sizeOfNumCPUs = MemoryLayout<uint>.size
            let status = sysctl(processor_info_array_t(mutating: mib.baseAddress), 2, &numCPUs, &sizeOfNumCPUs, nil, 0)
            if status != 0 {
                numCPUs = 1
            }
        }
        self.numCPUs = numCPUs

        // calling the updateInfo() func to initialize prevCpuInfo
        updateInfo()
        // sleep 1 second
        sleep(1)
        // calling the updateInfo() func to print cpu usage during past second
        updateInfo()
    }

    func updateInfo() {
        var numCPUsU: natural_t = 0
        let err: kern_return_t = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &numCPUsU, &cpuInfo, &numCpuInfo);
        guard err == KERN_SUCCESS else {
            print("Error host_processor_info!")
            return
        }

        // Two variables to calculate sum of all cores
        var totalInUse: Int32 = 0
        var totalTotal: Int32 = 0

        CPUUsageLock.lock()

        for i in 0 ..< Int32(numCPUs) {
            var inUse: Int32
            var total: Int32
            if let prevCpuInfo = prevCpuInfo {
                inUse = cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_USER)]
                    - prevCpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_USER)]
                    + cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_SYSTEM)]
                    - prevCpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_SYSTEM)]
                    + cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_NICE)]
                    - prevCpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_NICE)]
                total = inUse + (cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_IDLE)]
                    - prevCpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_IDLE)])
            } else {
                inUse = cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_USER)]
                    + cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_SYSTEM)]
                    + cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_NICE)]
                total = inUse + cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_IDLE)]
            }

            // Assigning totals here
            totalInUse += inUse
            totalTotal += total
        }
        CPUUsageLock.unlock()

        if let prevCpuInfo = prevCpuInfo {
            // I free the memory of prevCpuInfo
            let prevCpuInfoSize: size_t = MemoryLayout<integer_t>.stride * Int(numPrevCpuInfo)
            vm_deallocate(mach_task_self_, vm_address_t(bitPattern: prevCpuInfo), vm_size_t(prevCpuInfoSize))
            
            // I print sum of all cores percentage.
            let totalUsagePercentage = Float(totalInUse) / Float(totalTotal) * 100
            print(String(format: "Total CPU Usage: %.2f%%", totalUsagePercentage))
        }

        prevCpuInfo = cpuInfo
        numPrevCpuInfo = numCpuInfo

        cpuInfo = nil
        numCpuInfo = 0
    }
    
//    func hostCPULoadInfo() -> host_cpu_load_info? {
//        let HOST_CPU_LOAD_INFO_COUNT = MemoryLayout<host_cpu_load_info>.stride/MemoryLayout<integer_t>.stride
//        var size = mach_msg_type_number_t(HOST_CPU_LOAD_INFO_COUNT)
//        var cpuLoadInfo = host_cpu_load_info()
//
//        let result = withUnsafeMutablePointer(to: &cpuLoadInfo) {
//            $0.withMemoryRebound(to: integer_t.self, capacity: HOST_CPU_LOAD_INFO_COUNT) {
//                host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &size)
//            }
//        }
//        if result != KERN_SUCCESS{
//            print("Error  - \(#file): \(#function) - kern_result_t = \(result)")
//            return nil
//        }
//        return cpuLoadInfo
//    }
}
