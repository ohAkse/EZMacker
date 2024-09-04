//
//  AppCoreWLanStatus.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 9/1/24.
//

public enum AppCoreWLanStatus: Error, Equatable {
    case none
    case success
    case unableToFetchSignalStrength
    case scanningFailed
    case savePasswordFailed
    case disconnected
    case notFoundSSID
    case notFoundPassword
    case unknownError(error: String)

    public var description: String {
        switch self {
        case .none:
            return ""
        case .success:
            return "Wifi가 연결되었습니다."
        case .unableToFetchSignalStrength:
            return "신호세기를 알 수가 없습니다."
        case .scanningFailed:
            return "Wifi를 확인할 수 없습니다. 권한을 확인해주세요."
        case .savePasswordFailed:
            return "비밀번호 저장하는데 실패했습니다."
        case .disconnected:
            return "Wifi 연결이 해제되었습니다."
        case .notFoundSSID:
            return "Wifi를 찾을 수 없습니다."
        case .notFoundPassword:
            return "Wifi 비밀번호를 찾을 수 없습니다."
        case .unknownError(let error):
            return "알 수 없는 에러: \(error)"
        }
    }
    
    public static func == (lhs: AppCoreWLanStatus, rhs: AppCoreWLanStatus) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none),
             (.success, .success),
             (.unableToFetchSignalStrength, .unableToFetchSignalStrength),
             (.scanningFailed, .scanningFailed),
             (.savePasswordFailed, .savePasswordFailed),
             (.notFoundSSID, .notFoundSSID),
             (.disconnected, .disconnected),
             (.notFoundPassword, .notFoundPassword):
            
            return true
        case (.unknownError(let lError), .unknownError(let rError)):
            return lError == rError
        default:
            return false
        }
    }
}
