//
//  AppStorageKey.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import Foundation

enum AppStorageKey: String, Hashable {
    case colorSchme
    
    var name:String {
        switch self {
            case .colorSchme:
            return "colorSchme"
        }
    }
    var byDefault:String {
        switch self {
        case .colorSchme:
            return "Light"
        }
    }
}
