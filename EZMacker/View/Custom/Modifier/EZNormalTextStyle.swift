//
//  EZNormalTextStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI

struct EZNormalTextStyle: ViewModifier {
    var colorSchemeMode: String
    var fontSize: CGFloat
    var isBold: Bool

    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize, weight: isBold ? .bold : .regular))
            .foregroundColor(textColorForTheme())
    }

    private func textColorForTheme() -> Color {
        switch colorSchemeMode {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightBlack.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightWhite.color
        default:
            Logger.fatalErrorMessage("colorScheme is Empty")
            return Color.clear
        }
    }
}

extension View {
    func ezNormalTextStyle(colorSchemeMode: String, fontSize: CGFloat, isBold: Bool = false) -> some View {
        modifier(EZNormalTextStyle(colorSchemeMode: colorSchemeMode, fontSize: fontSize, isBold: isBold))
    }
}
