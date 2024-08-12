//
//  EZBackgroundColorStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI

struct EZBackgroundStyle: ViewModifier {
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
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightGray.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightBlue.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
    }
}

extension View {
    func ezBackgroundColorStyle() -> some View {
        modifier(EZBackgroundStyle())
    }
}
