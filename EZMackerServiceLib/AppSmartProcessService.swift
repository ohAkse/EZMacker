//
//  AppSmartProcessService.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 9/1/24.
//

import Foundation
import EZMackerUtilLib
import EZMackerThreadLib

public protocol AppSmartProcessProvidable {
    func processUpdateInfo()
    func checkProcessUpdateInfo()
    func getTotalPercenatage() -> Float
}

public class AppSmartProcessService: AppSmartProcessProvidable {
    private (set) var cpuInfo: processor_info_array_t!
    private (set) var prevCpuInfo: processor_info_array_t?
    private (set) var numCpuInfo: mach_msg_type_number_t = 0
    private (set) var numPrevCpuInfo: mach_msg_type_number_t = 0
    private (set) var totalUsagePercentage: Float = 0
    private let processQueue = DispatchQueueBuilder().createQueue(for: .cpuMonitoring)
    let numCPUs: uint
    let CPUUsageLock = NSLock()

    public init() {
        let mibKeys: [Int32] = [ CTL_HW, HW_NCPU ]
        var numCPUs: uint = 0
        mibKeys.withUnsafeBufferPointer { mib in
            var sizeOfNumCPUs = MemoryLayout<uint>.size
            let status = sysctl(processor_info_array_t(mutating: mib.baseAddress), 2, &numCPUs, &sizeOfNumCPUs, nil, 0)
            if status != 0 {
                numCPUs = 1
            }
        }
        self.numCPUs = numCPUs
        
        // 필요시 풀것
        #if PROFILE_INFO
        getSoftwareProcessInfo()
        #endif
    }
    func getSoftwareProcessInfo() {
        CommandToolRunner.runCommand(command: MDProfileCommand.software) { result in
            if let result = result {
                Logger.writeLog(.info, message: "System Profiler output: \(result)")
            } else {
                Logger.writeLog(.error, message: "System Profiler command failed")
            }
        }
    }
    
    public func checkProcessUpdateInfo() {
        processQueue.async {
            self.processUpdateInfo()
            sleep(1)
            self.processUpdateInfo()
        }
    }
    public func getTotalPercenatage() -> Float {
        return totalUsagePercentage
    }

    public func processUpdateInfo() {
        var numCPUsU: natural_t = 0
        let err: kern_return_t = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &numCPUsU, &cpuInfo, &numCpuInfo)
        guard err == KERN_SUCCESS else {
            Logger.writeLog(.error, message: "Error host_processor_info!")
            return
        }

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
            totalUsagePercentage = Float(totalInUse) / Float(totalTotal) * 100
        }

        prevCpuInfo = cpuInfo
        numPrevCpuInfo = numCpuInfo

        cpuInfo = nil
        numCpuInfo = 0
    }
}
