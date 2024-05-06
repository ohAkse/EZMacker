//
//  CategoryType.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import Foundation
enum CategoryType: CaseIterable {
    case smartBattery, smartFile
    var title: String {
        switch self {
        case .smartBattery: return "스마트 배터리"
        case .smartFile: return "스마트 파일"
        }
    }
    
    var imageName: String {
        switch self {
        case .smartBattery: return "bolt.square.fill"
        case .smartFile: return "square.inset.filled"
        }
    }
}

enum CategorySectionType {
    case categoryMainSection
    var title: String {
        switch self {
        case .categoryMainSection: return "메인 카테고리"
        }
    }
    var imageName: String {
        switch self {
        case .categoryMainSection: return "bolt.square.fill"
        }
    }
}
