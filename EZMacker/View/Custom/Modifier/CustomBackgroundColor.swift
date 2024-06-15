//
//  CustomBackgroundColor.swift
//  EZMacker
//
//  Created by 박유경 on 5/30/24.
//

import SwiftUI

struct CustomBackgroundModifier: ViewModifier {
    @EnvironmentObject var colorScheme: ColorSchemeViewModel
    
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(cardColorForTheme())
            )
            .cornerRadius(10)
    }
    private func cardColorForTheme() -> Color {
        switch colorScheme.getColorScheme() {
        case ColorSchemeMode.Light.title:
            return ThemeColor.lightGray.color
        case ColorSchemeMode.Dark.title:
            return ThemeColor.lightBlue.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
    }
}

extension View {
    func customBackgroundColor() -> some View {
        modifier(CustomBackgroundModifier())
    }
}
