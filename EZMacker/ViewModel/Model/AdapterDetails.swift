//
//  AdapterDetails.swift
//  EZMacker
//
//  Created by 박유경 on 5/18/24.
//

import Foundation
enum AdapterError: Error {
    case dataNotFound
    case serializationFailed
    case decodingFailed
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .dataNotFound:
            Logger.writeLog(.error, message: "Data not found.")
            return "Data not found."
        case .serializationFailed:
            Logger.writeLog(.error, message: "Failed to serialize data.")
            return "Failed to serialize data."
        case .decodingFailed:
            Logger.writeLog(.error, message: "Failed to decode data.")
            return "Failed to decode data."
        case .unknown(let error):
            Logger.writeLog(.error, message: "error.localizedDescription.")
            return error.localizedDescription
        }
    }
}


struct AdapterDetails: Decodable {
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

