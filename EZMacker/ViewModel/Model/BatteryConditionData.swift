//
//  BatteryConditionData.swift
//  EZMacker
//
//  Created by 박유경 on 8/31/24.
//

import Foundation

struct BatteryConditionData {
    var cycleCount: Int
    var temperature: Int
    var batteryMaxCapacity: Int
    var designedCapacity: Int
    var healthState: String
    var batteryCellDisconnectCount: Int
    
    init(cycleCount: Int = -1, temperature: Int = -1, batteryMaxCapacity: Int = -1, designedCapacity: Int = -1, healthState: String = "", batteryCellDisconnectCount: Int = -1) {
        self.cycleCount = cycleCount
        self.temperature = temperature
        self.batteryMaxCapacity = batteryMaxCapacity
        self.designedCapacity = designedCapacity
        self.healthState = healthState
        self.batteryCellDisconnectCount = batteryCellDisconnectCount
    }
}
