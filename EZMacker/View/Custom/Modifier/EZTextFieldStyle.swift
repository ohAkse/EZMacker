//
//  EZTextFieldStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI

struct EZTextFieldStyle: ViewModifier {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
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
                    .stroke(borderColorForTheme(), lineWidth: 1)
            )
    }
    
    private func backgroundColorForTheme() -> Color {
        switch colorSchemeViewModel.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightGray.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightBlue.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
    }
    
    private func borderColorForTheme() -> Color {
        switch colorSchemeViewModel.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightGray.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightBlue.color
        default:
            return Color.clear
        }
    }
    private func foregroundColorForTheme() -> Color {

        switch colorSchemeViewModel.getColorScheme() {
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
