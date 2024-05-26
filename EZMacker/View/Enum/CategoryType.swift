//
//  CategoryType.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import Foundation
enum CategoryType: CaseIterable {
    case smartBattery, smartFile, smartWifi,smartNotificationAlarm
    var title: String {
        switch self {
        case .smartBattery: return "스마트 배터리"
        case .smartFile: return "스마트 파일"
        case .smartWifi: return "스마트 와이파이"
        case .smartNotificationAlarm: return "알람 메시지"
        }
    }
    
    var imageName: String {
        switch self {
        case .smartBattery: return "bolt.square.fill"
        case .smartFile: return "square.inset.filled"
        case .smartWifi: return "square.inset.filled"
        case .smartNotificationAlarm: return "square.inset.filled"
        }
    }
}

enum CategorySectionType {
    case categoryMainSection, settingSection
    var title: String {
        switch self {
        case .categoryMainSection: return "My Mac"
        case .settingSection: return "환경 설정"
        }
    }
    var imageName: String {
        switch self {
        case .categoryMainSection: return "bolt.square.fill"
        case .settingSection: return "bolt.square.fill"
        }
    }
}
