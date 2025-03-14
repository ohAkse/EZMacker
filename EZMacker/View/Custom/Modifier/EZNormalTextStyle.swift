//
//  EZNormalTextStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI
import EZMackerUtilLib

struct EZNormalTextStyle: ViewModifier {
    @EnvironmentObject var systemThemeService: SystemThemeService
    let fontSize: CGFloat
    let isBold: Bool

    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize, weight: isBold ? .bold : .regular))
            .foregroundColor(textColorForTheme())
    }

    private func textColorForTheme() -> Color {
        switch systemThemeService.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightBlack.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightWhite.color
        default:
            Logger.fatalErrorMessage("colorScheme is Empty")
            return Color.primary
        }
    }
}

extension View {
    func ezNormalTextStyle(fontSize: CGFloat, isBold: Bool = false) -> some View {
        modifier(EZNormalTextStyle(fontSize: fontSize, isBold: isBold))
    }
}
