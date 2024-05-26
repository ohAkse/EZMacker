//
//  BatteryWithExit.swift
//  EZMacker
//
//  Created by 박유경 on 5/26/24.
//

enum BatteryExitOption: String, CaseIterable {
    case unused = "사용안함"
    case normal = "절반이상"
    case overuse = "과사용"
    
    var value: String {
        return self.rawValue
    }
}
