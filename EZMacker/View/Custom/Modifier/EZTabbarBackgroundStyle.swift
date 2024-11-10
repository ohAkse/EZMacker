//
//  EZTabbarBackgroundStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI
import EZMackerUtilLib

struct EZTabbarBackgroundStyle: ViewModifier {
    @EnvironmentObject var systemThemeService: SystemThemeService

    func body(content: Content) -> some View {
        content
            .background(backgroundColor())
    }

    private func backgroundColor() -> Color {
        switch systemThemeService.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.darkGray.color.opacity(0.8)
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.softGray.color
        default:
            Logger.fatalErrorMessage("colorScheme is Empty")
            return Color.primary
        }
    }
}

extension View {
    func ezTabbarBackgroundStyle() -> some View {
        self.modifier(EZTabbarBackgroundStyle())
    }
}
