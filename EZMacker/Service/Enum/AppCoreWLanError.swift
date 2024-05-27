//
//  AppCoreWLanError.swift
//  EZMacker
//
//  Created by 박유경 on 5/27/24.
//

import Foundation
enum AppCoreWLanError: Error {
    case unableToFetchSignalStrength
    
    var errorName: String {
        switch self {
        case .unableToFetchSignalStrength:
            return "신호세기를 알수가 없습니다."
        }
    }
}
