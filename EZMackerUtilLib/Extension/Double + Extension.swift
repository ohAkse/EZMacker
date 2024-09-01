//
//  Double + Extension.swift
//  EZMackerUtilLib
//
//  Created by 박유경 on 9/1/24.
//

import Foundation

public extension Double {
    func toMBps() -> String {
        return String(format: "%.2f Mbps", self)
    }
}
