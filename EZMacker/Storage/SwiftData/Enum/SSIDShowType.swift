//
//  BestSSIDShowType.swift
//  EZMacker
//
//  Created by 박유경 on 9/14/24.
//

import Foundation
import EZMackerUtilLib

enum SSIDShowType: String, CaseIterable, Reflectable {
    case alert = "메세지 박스 형태로 보이기"
    case notification = "알림메시지 형태로 보이기"
    
    var typeName: String {
        return String(describing: type(of: self))
    }
}
