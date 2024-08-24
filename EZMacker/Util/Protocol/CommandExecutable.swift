//
//  CommandExecutable.swift
//  EZMacker
//
//  Created by 박유경 on 8/18/24.
//

import Foundation

protocol CoomandExecutable {
    var executableURL: URL { get }
    var argumentsList: [[String]] { get }
}
