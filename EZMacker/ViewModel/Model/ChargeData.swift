//
//  ChargeData.swift
//  EZMacker
//
//  Created by 박유경 on 5/26/24.
//

import Foundation

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

// MARK: notChargingReason 정보 수집중
// 0x400001: 완충됐을때 에러코드?
