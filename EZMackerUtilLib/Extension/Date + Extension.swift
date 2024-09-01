//
//  Date + Extension.swift
//  EZMackerUtilLib
//
//  Created by 박유경 on 9/1/24.
//

import Foundation

public extension Date {
    func getCurrentTime(Dataforamt: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Dataforamt
        let dateString = formatter.string(from: self)
        return dateString
    }
    func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}
