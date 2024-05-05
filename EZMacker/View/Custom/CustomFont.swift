//
//  CustomFont.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import SwiftUI
struct CustomTextModifier: ViewModifier {
    var textColor: Color
    var fontSize: CGFloat
    
    func body(content: Content) -> some View {
        content.font(.system(size: fontSize))
            .foregroundColor(textColor)
    }
}

extension View {
    func customText(textColor: Color, fontSize: CGFloat) -> some View {
        modifier(CustomTextModifier(textColor: textColor, fontSize: fontSize))
    }
}
