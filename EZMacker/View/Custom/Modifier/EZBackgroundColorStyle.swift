//
//  EZBackgroundColorStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI
import EZMackerUtilLib

struct EZBackgroundStyle: ViewModifier {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(foregroundColorForTheme())
            )
            .cornerRadius(12)
    }
    private func foregroundColorForTheme() -> Color {
        switch colorSchemeViewModel.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightGray.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightDark.color
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
