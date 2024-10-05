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
            return "비율 유지하기"
        case .fillFrame:
            return "이미지 리사이즈"
        }
    }
}
