//
//  EZTabbarGridStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI

struct EZTabbarGridStyle: ViewModifier {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel

    func body(content: Content) -> some View {
        content
            .background(backgroundColor())
            .cornerRadius(12)
            .shadow(color: shadowColor(), radius: 5, x: 0, y: 2)
    }

    private func backgroundColor() -> Color {
        switch colorSchemeViewModel.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightGreen.color.opacity(0.1)
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightRed.color.opacity(0.2) 
        default:
            Logger.fatalErrorMessage("colorScheme is Empty")
            return Color.primary
        }
    }
    
    private func shadowColor() -> Color {
        switch colorSchemeViewModel.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return Color.black.opacity(0.1)
        case ColorSchemeModeType.Dark.title:
            return Color.white.opacity(0.1)
        default:
            return Color.clear
        }
    }
}

extension View {
    func ezTabbarGridStyle() -> some View {
        self.modifier(EZTabbarGridStyle())
    }
}
