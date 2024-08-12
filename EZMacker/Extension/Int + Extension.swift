//
//  Int + Extension.swift
//  EZMacker
//
//  Created by 박유경 on 5/7/24.
//

import Foundation

extension Int {
    func toBun() -> String {
        if self == 0 {return "계산중.."}
        return String(self) + "번"
        
    }
    
    func toHourMinute() -> String {
        if self == 0 || self == -1 || self == 65535 {return "계산중.."}
        

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
        if self == 0 {return "계산중.."}
        
        let degree = Double(self) / 100.0
        return String(format: "%.2f도", degree)
    }
    func toCapacityPerent() -> String {
        if self == 0 {return "계산중.."}
        return String(self) + "%"
    }
    
    func tomAH() -> String {
        if self == 0 {return "계산중.."}
        return String(self) + "(mAH)"
    }
    
    //SwiftUI에서는 기본적으로 문자열이 숫자일때 ,로찍혀서 나오는듯
    func toNumber() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    static func extractNumericPart(from option: String) -> Int? {
        let pattern = #"\d+"# 
        if let range = option.range(of: pattern, options: .regularExpression) {
            let numericPart = option[range]
            return Int(numericPart)
        }
        return nil
    }
}
