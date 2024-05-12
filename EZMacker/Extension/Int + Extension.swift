//
//  Int + Extension.swift
//  EZMacker
//
//  Created by 박유경 on 5/7/24.
//

import Foundation

extension Int {
    func toHourMinute() -> String {
        if self == 65535 {
            return "계산중 .."
        }
        let hours = self / 60
        let minutes = self % 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours)시간 \(minutes)분"
        } else if hours > 0 {
            return "\(hours)시간"
        } else if minutes > 0 {
            return "\(minutes)분"
        } else {
            return "0분"
        }
    }
    func toDegree() -> String {
        let degree = Double(self) / 100.0
        return String(format: "%.2f도", degree)
    }
    func toCapacityPerent() -> String {
        return String(self) + "%"
    }
    
    func tomAH() -> String {
        return String(self) + "(mAH)"
    }
}
