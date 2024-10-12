//
//  EZPopupStyle.swift
//  EZMacker
//
//  Created by 박유경 on 10/12/24.
//

import SwiftUI

struct EZPopupStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 220, height: 200)
            .padding()
            .background(Color(.windowBackgroundColor))
            .cornerRadius(12)
            .shadow(radius: 5)
    }
}

extension View {
    func ezPopupStyle() -> some View {
        self.modifier(EZPopupStyle())
    }
}
