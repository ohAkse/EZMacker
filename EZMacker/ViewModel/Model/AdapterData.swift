//
//  AdapterData.swift
//  EZMacker
//
//  Created by 박유경 on 6/3/24.
//

import Foundation

struct AdapterData: Decodable {
    var AdapterID: Int
    var AdapterVoltage: Int
    var Current: Int
    var Description: String
    var FamilyCode: Int
    var FwVersion: String
    var HwVersion: String
    var IsWireless: Bool
    var Manufacturer: String
    var Model: String
    var Name: String
    var PMUConfiguration: Int
    var SerialString: String
    var UsbHvcHvcIndex: Int
    var UsbHvcMenu: [UsbHvcMenuEntry]
    var Watts: Int

    struct UsbHvcMenuEntry: Codable {
        var Index: Int
        var MaxCurrent: Int
        var MaxVoltage: Int
    }
}

