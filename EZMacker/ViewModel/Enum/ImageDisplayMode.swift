//
//  ImageDisplayMode.swift
//  EZMacker
//
//  Created by 박유경 on 10/5/24.
//

import Foundation

enum ImageDisplayMode {
    case keepAspectRatio
    case fillFrame
    
    var description: String {
        switch self {
        case .keepAspectRatio:
            return "비율 유지"
        case .fillFrame:
            return "전체비율 유지"
        }
    }
}
