//
//  CWInterfaceMode + Extension.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 10/13/24.
//

import CoreWLAN

public extension CWInterfaceMode {
    var description: String {
        switch self {
        case .none:
            return "None"
        case .station:
            return "Station"
        case .IBSS:
            return "IBSS"
        case .hostAP:
            return "Host AP"
        @unknown default:
            return "Unknown"
        }
    }
}
