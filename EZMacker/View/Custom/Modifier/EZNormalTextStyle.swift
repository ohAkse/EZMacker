//
//  EZNormalTextStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI

struct EZNormalTextStyle: ViewModifier {
    @EnvironmentObject var colorScheme: ColorSchemeViewModel
    var fontSize: CGFloat
    var isBold: Bool

    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize, weight: isBold ? .bold : .regular))
            .foregroundColor(textColorForTheme())
    }

    private func textColorForTheme() -> Color {
        switch colorScheme.getColorScheme() {
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
