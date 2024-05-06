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
    
    func getCurrentChatTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.amSymbol = "오전"
        formatter.pmSymbol = "오후"
        let dateString = formatter.string(from: self)
        return dateString
    }
}
