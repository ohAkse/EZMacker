//
//  FontSizeType.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import Foundation
enum FontSizeType {
    case small
    case medium
    case large
    
    var size: CGFloat {
        switch self {
        case .small: 15
        case .medium: 20
        case .large: 23
        }
    }
}
