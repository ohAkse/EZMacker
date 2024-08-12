//
//  EZListViewStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI

struct EZListViewStyle: ViewModifier {
    let backgroundColor: Color
    
    init(backgroundColor: Color = .white) {
        self.backgroundColor = backgroundColor
    }
    
    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .listStyle(PlainListStyle())
            .background(backgroundColor)
            .cornerRadius(12)
    }
}

extension View {
    func ezListViewStyle(backgroundColor: Color = .white) -> some View {
        self.modifier(EZListViewStyle(backgroundColor: backgroundColor))
    }
}
