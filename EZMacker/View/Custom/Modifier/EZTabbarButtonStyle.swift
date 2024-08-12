//
//  EZTabbarButtonStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI

struct EZTabbarButtonStyle: ViewModifier {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel

    func body(content: Content) -> some View {
        content
            .buttonStyle(PlainButtonStyle())
            .frame(width: 100)
            .background(backgroundColor())
            .cornerRadius(12)
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .padding(5)
    }
    
    private func backgroundColor() -> Color {
        switch colorSchemeViewModel.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightBlue.color.opacity(0.8)
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.darkBrown.color.opacity(0.7)
        default:
            Logger.fatalErrorMessage("colorScheme is Empty")
            return Color.primary
        }
    }
}

extension View {
    func ezTabbarButtonStyle() -> some View {
        self.modifier(EZTabbarButtonStyle())
    }
}
