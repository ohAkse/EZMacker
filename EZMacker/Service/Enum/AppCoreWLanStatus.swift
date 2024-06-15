//
//  AppCoreWLanError.swift
//  EZMacker
//
//  Created by 박유경 on 5/27/24.
//

import Foundation

enum AppCoreWLanStatus: Error, Equatable {
    case none
    case success
    case unableToFetchSignalStrength
    case scanningFailed
    case savePasswordFailed
    case notFoundSSID
    case notFoundPassword
    case unknownError(error: String)

    var errorName: String {
        switch self {
        case .success, .none:
            return ""
        case .unableToFetchSignalStrength:
            return "신호세기를 알 수가 없습니다."
        case .scanningFailed:
            return "와이파이 리스트를 얻는데 실패했습니다."
        case .savePasswordFailed:
            return "비밀번호 저장하는데 실패했습니다."
        case .notFoundSSID:
            return "와이파이를 찾을 수 없습니다."
        case .notFoundPassword:
            return "와이파이 비밀번호를 찾을 수 없습니다."
        case .unknownError(let error):
            return "알 수 없는 에러: \(error)"
        }
    }
    
    static func ==(lhs: AppCoreWLanStatus, rhs: AppCoreWLanStatus) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none),
             (.success, .success),
             (.unableToFetchSignalStrength, .unableToFetchSignalStrength),
             (.scanningFailed, .scanningFailed),
             (.savePasswordFailed, .savePasswordFailed),
             (.notFoundSSID, .notFoundSSID),
             (.notFoundPassword, .notFoundPassword):
            return true
        case (.unknownError(let lError), .unknownError(let rError)):
            return lError == rError
        default:
            return false
        }
    }
}

