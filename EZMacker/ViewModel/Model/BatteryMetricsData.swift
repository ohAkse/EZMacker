//
//  BatteryMetricsData.swift
//  EZMacker
//
//  Created by 박유경 on 8/31/24.
//

import Foundation

struct BatteryMetricsData {
    var currentBatteryCapacity: Double
    var remainingTime: Int
    var chargingTime: Int
    var chargeData: [ChargeData]
    
    init(currentBatteryCapacity: Double = 0, remainingTime: Int = 0, chargingTime: Int = 0, chargeData: [ChargeData] = []) {
        self.currentBatteryCapacity = currentBatteryCapacity
        self.remainingTime = remainingTime
        self.chargingTime = chargingTime
        self.chargeData = chargeData
    }
}
