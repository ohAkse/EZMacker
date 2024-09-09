//
//  AdapterConnectStatus.swift
//  EZMacker
//
//  Created by 박유경 on 6/3/24.
//

import Foundation
import EZMackerUtilLib

enum AdapterConnect: Error, Equatable {
    case dataNotFound
    case decodingFailed
    case success
    case none
    case processing
    case unknown(Error)
    var localizedDescription: String {
        switch self {
        case .dataNotFound:
            Logger.writeLog(.error, message: "Data not found.")
            return "어댑터 정보를 찾을 수 없습니다."
        case .decodingFailed:
            Logger.writeLog(.error, message: "decodingFailed")
            return "어댑터 정보를 해독하는데 실패했습니다."
        case .success:
            Logger.writeLog(.error, message: "Failed to decode data.")
            return ""
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
