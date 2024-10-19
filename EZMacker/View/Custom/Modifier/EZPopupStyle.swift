//
//  EZPopupStyle.swift
//  EZMacker
//
//  Created by 박유경 on 10/12/24.
//

import SwiftUI
import EZMackerUtilLib

struct EZPopupStyle: ViewModifier {
    @EnvironmentObject var systemThemeService: SystemThemeService
    func body(content: Content) -> some View {
        content
            .frame(width: 200, height: 200)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(foregroundColorForTheme())
            )
            .cornerRadius(12)
            .shadow(radius: 5)
    }
    private func foregroundColorForTheme() -> Color {
        switch systemThemeService.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightModeLavender.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.darkModeSlateGray.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
    }
}

extension View {
    func ezPopupStyle() -> some View {
        self.modifier(EZPopupStyle())
    }
}
