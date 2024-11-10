//
//  MDMulticastCommand.swift
//  EZMackerUtilLib
//
//  Created by 박유경 on 10/14/24.
//

import Foundation
public enum MDMulticastCommand: CoomandExecutable {
    case getGroups
    case getRoutes
    case checkInterface(interface: String)
    
    public var executableURL: URL {
        switch self {
        case .getGroups, .getRoutes:
            return URL(fileURLWithPath: "/usr/sbin/netstat")
        case .checkInterface:
            return URL(fileURLWithPath: "/sbin/ifconfig")
        }
    }
    
    public var argumentsList: [[String]] {
        switch self {
        case .getGroups:
            return [["-g"]]
        case .getRoutes:
            return [["-rn"]]
        case .checkInterface(let interface):
            return [[interface]]
        }
    }
}
