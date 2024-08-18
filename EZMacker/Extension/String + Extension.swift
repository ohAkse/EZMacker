//
//  String + Extension.swift
//  EZMacker
//
//  Created by 박유경 on 8/13/24.
//

import SwiftUI

extension String {
    func getActualButtonWidth(fontSize: CGFloat = 15, minimumWidth: CGFloat = 80) -> CGFloat {
        let font = NSFont.systemFont(ofSize: fontSize)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: attributes)
        
        return max(size.width , minimumWidth)
    }
    
    func converFileType() -> String {
        switch self {
        case "NSFileTypeDirectory":
            return "폴더"
        case "NSFileTypeRegular":
            return "파일"
        case "NSFileTypeSymbolicLink":
            return "심볼릭 링크"
        case "NSFileTypeSocket":
            return "소켓"
        case "NSFileTypeCharacterSpecial":
            return "문자 장치"
        case "NSFileTypeBlockSpecial":
            return "블록 장치"
        case "NSFileTypeUnknown":
            return "알 수 없는 파일"
        default:
            return self
        }
    }
}

