//
//  EZListRowStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI

struct EZListRowStyle: ViewModifier {
    let backgroundColor: Color
    
    init(backgroundColor: Color = .white) {
        self.backgroundColor = backgroundColor
    }
    
    func body(content: Content) -> some View {
        content
            .listRowBackground(backgroundColor)
    }
}

extension View {
    func ezListRowStyle(backgroundColor: Color = .white) -> some View {
        self.modifier(EZListRowStyle(backgroundColor: backgroundColor))
    }
}
