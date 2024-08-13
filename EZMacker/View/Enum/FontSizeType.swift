//
//  FontSizeType.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import Foundation
enum FontSizeType {
    case extrasmall
    case small
    case medium
    case large
    case superLarge
    
    var size: CGFloat {
        switch self {
        case .extrasmall: 12
        case .small: 15
        case .medium: 20
        case .large: 25
        case .superLarge: 30
        }
    }
}
