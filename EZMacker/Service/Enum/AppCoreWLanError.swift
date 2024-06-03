//
//  AppCoreWLanError.swift
//  EZMacker
//
//  Created by 박유경 on 5/27/24.
//

import Foundation
enum AppCoreWLanError: Error {
    case unableToFetchSignalStrength
    case scanningFailed
    var errorName: String {
        switch self {
        case .unableToFetchSignalStrength:
            return "신호세기를 알수가 없습니다."
        case .scanningFailed:
            return "와이파이 리스트를 얻는데 실패했습니다."
        }
    }
}
