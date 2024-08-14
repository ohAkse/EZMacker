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
}

