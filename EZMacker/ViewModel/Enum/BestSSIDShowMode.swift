//
//  BestSSIDShowOption.swift
//  EZMacker
//
//  Created by 박유경 on 6/16/24.
//

enum BestSSIDShowMode: String, CaseIterable {
    case alert = "메세지 박스 형태로 보이기"
    case notification = "알림메시지 형태로 보이기"
    
    var value: String {
        return self.rawValue
    }
}
