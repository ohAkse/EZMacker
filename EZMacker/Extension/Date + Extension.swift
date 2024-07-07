//
//  Date + Extension.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import Foundation

extension Date {
    func getCurrentTime(Dataforamt: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Dataforamt
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd HH:mm"
        formatter.timeZone = TimeZone.current // 로컬 시간대로 설정
        return formatter.string(from: self)
    }
}
