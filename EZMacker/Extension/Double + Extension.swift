//
//  Double + Extension.swift
//  EZMacker
//
//  Created by 박유경 on 5/27/24.
//

import Foundation
extension Double {
    func toMBps() -> String {
        return String(format: "%.2f Mbps", self)
    }
}
