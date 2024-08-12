//
//  EZTextFieldStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI

struct EZTextFieldStyle: ViewModifier {
    let backgroundColor: Color
    
    init(backgroundColor: Color = .white) {
        self.backgroundColor = backgroundColor
    }
    
    func body(content: Content) -> some View {
        content
            .textFieldStyle(PlainTextFieldStyle())
            .background(backgroundColor)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.clear))
    }
}

extension View {
    func ezTextFieldStyle(backgroundColor: Color = .white) -> some View {
        self.modifier(EZTextFieldStyle(backgroundColor: backgroundColor))
    }
}
