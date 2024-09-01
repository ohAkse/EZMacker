//
//  MDProfileCommand.swift
//  EZMackerUtilLib
//
//  Created by 박유경 on 9/1/24.
//

import Foundation

public enum MDProfileCommand: CoomandExecutable {
    case hardware
    case software

    public var executableURL: URL {
        return URL(fileURLWithPath: "/usr/sbin/system_profiler")
    }

    public var argumentsList: [[String]] {
        switch self {
        case .hardware:
            return [["SPHardwareDataType", "-json"]]
        case .software:
            return [["SPSoftwareDataType", "-json"]]
        }
    }
}
