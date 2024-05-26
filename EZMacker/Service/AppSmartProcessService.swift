//
//  AppSmartProcessService.swift
//  EZMacker
//
//  Created by 박유경 on 5/26/24.
//

import Foundation

protocol AppSmartProcessProvidable {
    func processUpdateInfo()
}

class AppSmartProcessService: AppSmartProcessProvidable {
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

        processUpdateInfo()
        sleep(1)
        processUpdateInfo()
    }

    func processUpdateInfo() {
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
}
