//
//  AdapterConnectStatus.swift
//  EZMacker
//
//  Created by 박유경 on 6/3/24.
//

import Foundation

enum AdapterConnect: Error, Equatable {
    case dataNotFound
    case serializationFailed
    case decodingFailed
    case success
    case none
    case processing
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
            Logger.writeLog(.error, message: "decodingFailed")
            return "decodingFailed"
        case .success:
            Logger.writeLog(.error, message: "Failed to decode data.")
            return "success"
        case .processing:
            Logger.writeLog(.error, message: "processing data.")
            return "processing data."
        case .none:
            Logger.writeLog(.error, message: "none")
            return "none"
        case .unknown(let error):
            Logger.writeLog(.error, message: "error.localizedDescription.")
            return error.localizedDescription
        }
    }
    static func == (lhs: AdapterConnect, rhs: AdapterConnect) -> Bool {
        switch (lhs, rhs) {
        case (.dataNotFound, .dataNotFound),
             (.serializationFailed, .serializationFailed),
             (.decodingFailed, .decodingFailed),
             (.success, .success),
             (.none, .none),
             (.processing, .processing):
            return true
        case (.unknown(let error1), .unknown(let error2)):
            return error1.localizedDescription == error2.localizedDescription
        default:
            return false
        }
    }
}
