//
//  EZFilterButtonStyle.swift
//  EZMacker
//
//  Created by 박유경 on 10/27/24.
//

import SwiftUI
import EZMackerUtilLib

struct EZPopupButtonStyle: ButtonStyle {
    @EnvironmentObject var systemThemeService: SystemThemeService
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .foregroundColor(foregroundColor())
            .background(backgroundColor())
            .cornerRadius(8)
            .shadow(color: shadowColor(), radius: 5, x: 0, y: 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
    
    private func backgroundColor() -> Color {
        switch systemThemeService.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.cyan.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.softWhite.color
        default:
            Logger.fatalErrorMessage("colorScheme is Empty")
            return Color.clear
        }
    }
    private func foregroundColor() -> Color {
        switch systemThemeService.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.white.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.white.color.opacity(0.9)
        default:
            Logger.fatalErrorMessage("foregroundColor is Empty")
            return Color.clear
        }
    }
    private func shadowColor() -> Color {
        switch systemThemeService.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return Color.black.opacity(0.1)
        case ColorSchemeModeType.Dark.title:
            return Color.white.opacity(0.05)
        default:
            Logger.fatalErrorMessage("shadowColor is Empty")
            return Color.clear
        }
    }
}

extension View {
    func ezPopupButtonStyle() -> some View {
        self.buttonStyle(EZPopupButtonStyle())
    }
}
