//
//  BatteryWithExit.swift
//  EZMacker
//
//  Created by 박유경 on 6/3/24.
//

import Foundation

enum BatteryExitOption: String, CaseIterable {
    case unused = "사용안함"
    case normal = "50%"
    case overuse = "90%"
    
    var value: String {
        return self.rawValue
    }
}
