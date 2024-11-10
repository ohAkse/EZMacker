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
    var Description: String?
    var FamilyCode: Int?
    var FwVersion: String?
    var HwVersion: String?
    var IsWireless: Bool
    var Manufacturer: String?
    var Model: String?
    var Name: String?
    var PMUConfiguration: Int
    var SerialString: String?
    var UsbHvcHvcIndex: Int?
    var UsbHvcMenu: [UsbHvcMenuEntry]
    var Watts: Int

    struct UsbHvcMenuEntry: Codable {
        var Index: Int
        var MaxCurrent: Int
        var MaxVoltage: Int
    }

    var isCType: Bool {
        
        return (Model?.isEmpty == nil) && (Manufacturer?.isEmpty == nil)
      }
    init(AdapterID: Int =  0,
         AdapterVoltage: Int = 0,
         Current: Int = 0,
         Description: String = "",
         FamilyCode: Int = 0,
         FwVersion: String = "",
         HwVersion: String = "",
         IsWireless: Bool = false,
         Manufacturer: String = "",
         Model: String = "",
         Name: String = "",
         PMUConfiguration: Int = 0,
         SerialString: String = "",
         UsbHvcHvcIndex: Int = 0,
         UsbHvcMenu: [UsbHvcMenuEntry] = [],
         Watts: Int = 0) {
        self.AdapterID = AdapterID
        self.AdapterVoltage = AdapterVoltage
        self.Current = Current
        self.Description = Description
        self.FamilyCode = FamilyCode
        self.FwVersion = FwVersion
        self.HwVersion = HwVersion
        self.IsWireless = IsWireless
        self.Manufacturer = Manufacturer
        self.Model = Model
        self.Name = Name
        self.PMUConfiguration = PMUConfiguration
        self.SerialString = SerialString
        self.UsbHvcHvcIndex = UsbHvcHvcIndex
        self.UsbHvcMenu = UsbHvcMenu
        self.Watts = Watts
    }
}
