//
//  MDProfileQuery.swift
//  EZMacker
//
//  Created by 박유경 on 8/18/24.
//

import Foundation

enum MDProfileCommand: CoomandExecutable {
    case hardware
    case software
    
    var executableURL: URL {
        return URL(fileURLWithPath: "/usr/sbin/system_profiler")
    }
    
    var argumentsList: [[String]] {
        switch self {
        case .hardware:
            return [["SPHardwareDataType", "-json"]]
        case .software:
            return [["SPSoftwareDataType", "-json"]]
        }
    }
}
