//
//  EZTextFieldWrapperStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/13/24.
//

import SwiftUI

import SwiftUI

struct EZTextFieldWrapperStyle: ViewModifier {
    private var colorSchemeViewModel: ColorSchemeViewModel = ColorSchemeViewModel()

    private var dynamicBackgroundColor: Color {
        switch colorSchemeViewModel.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.white.color
        case ColorSchemeModeType.Dark.title:
            return Color(red: 161/255, green: 161/255, blue: 165/255)
        default:
            Logger.fatalErrorMessage("colorScheme is Empty")
            return Color.clear
        }
    }

    func body(content: Content) -> some View {
        content
            .background(dynamicBackgroundColor)
            .cornerRadius(6)
            .padding(.leading, 3)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(red: 110/255, green: 110/255, blue: 110/255), lineWidth: 0.3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.clear)
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 3)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 6)
                    )
            )
    }
}

extension View {
    func ezTextFieldWrapperStyle() -> some View {
        self.modifier(EZTextFieldWrapperStyle())
    }
}
