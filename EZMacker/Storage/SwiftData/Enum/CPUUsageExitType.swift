//
//  CPUUsageExitType.swift
//  EZMacker
//
//  Created by 박유경 on 9/14/24.
//

import Foundation
import EZMackerUtilLib

enum CPUUsageExitType: String, CaseIterable, Reflectable {
    case unused = "사용안함"
    case normal = "50%"
    case overuse = "90%"
        
    var typeName: String {
        return String(describing: type(of: self))
    }
}
