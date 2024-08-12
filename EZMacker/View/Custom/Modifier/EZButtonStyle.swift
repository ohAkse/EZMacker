//
//  EZButtonStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI

struct EZButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    let baseColor: Color
    
    init(baseColor: Color = .blue) {
        self.baseColor = baseColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(dynamicBackgroundColor)
            .foregroundColor(.white)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
    
    private var dynamicBackgroundColor: Color {
        switch colorScheme {
        case .light:
            return baseColor.opacity(0.8)
        case .dark:
            return baseColor.opacity(0.6)
        @unknown default:
            return baseColor
        }
    }
}

extension View {
    func ezButtonStyle(baseColor: Color = .blue) -> some View {
        self.buttonStyle(EZButtonStyle(baseColor: baseColor))
    }
}
