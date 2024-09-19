//
//  EZTextFieldStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI
import EZMackerUtilLib

struct EZTextFieldStyle: ViewModifier {
    @EnvironmentObject var appThemeManager: AppThemeManager
    let customBackgroundColor: Color?
    let customBorderColor: Color?
    
    init(backgroundColor: Color? = nil, borderColor: Color? = nil) {
        self.customBackgroundColor = backgroundColor
        self.customBorderColor = borderColor
    }
    
    func body(content: Content) -> some View {
        content
            .textFieldStyle(PlainTextFieldStyle())
            .foregroundColor(foregroundColorForTheme())
            .background(backgroundColorForTheme())
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.clear, lineWidth: 1)
            )
    }
    
    private func backgroundColorForTheme() -> Color {
        switch appThemeManager.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightGray.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightDark.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
    }
    private func foregroundColorForTheme() -> Color {
        switch appThemeManager.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.black.color.opacity(0.7)
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.white.color
        default:
            return Color.primary
        }
    }
}

extension View {
    func ezTextFieldStyle(backgroundColor: Color? = nil, borderColor: Color? = nil) -> some View {
        self.modifier(EZTextFieldStyle(backgroundColor: backgroundColor, borderColor: borderColor))
    }
}
