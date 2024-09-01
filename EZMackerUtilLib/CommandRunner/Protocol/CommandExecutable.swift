//
//  CommandExecutable.swift
//  EZMackerUtilLib
//
//  Created by 박유경 on 9/1/24.
//

import Foundation

public protocol CoomandExecutable {
    var executableURL: URL { get }
    var argumentsList: [[String]] { get }
}
