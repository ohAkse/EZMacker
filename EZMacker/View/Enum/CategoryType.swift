//
//  CategoryType.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import Foundation
enum CategoryType: CaseIterable {
    case smartBattery, smartFileSearch, smartWifi,smartNotificationAlarm, smartFileLocator
    var title: String {
        switch self {
        case .smartBattery: return "스마트 배터리"
        case .smartFileSearch: return "스마트 검색"
        case .smartWifi: return "스마트 와이파이"
        case .smartFileLocator: return "스마트 파일 로케이터"
        case .smartNotificationAlarm: return "알람 메시지"
        }
    }
    
    var imageName: String {
        switch self {
        case .smartBattery: return "bolt.square.fill"
        case .smartFileSearch: return "square.inset.filled"
        case .smartWifi: return "square.inset.filled"
        case .smartFileLocator: return "square.inset.filled"
        case .smartNotificationAlarm: return "square.inset.filled"
        }
    }
}

enum CategorySectionType {
    case categoryMainSection, settingSection,categoryUtilitySection
    var title: String {
        switch self {
        case .categoryMainSection: return "My Mac"
        case .categoryUtilitySection: return "유틸리티"
        case .settingSection: return "환경 설정"
        }
    }
}
