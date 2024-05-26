//
//  CustomNormalTextFont.swift
//  EZMacker
//
//  Created by 박유경 on 5/14/24.
//

import SwiftUI
struct CustomNormalTextModifier: ViewModifier {
    @EnvironmentObject var colorScheme: ColorSchemeViewModel
    var fontSize: CGFloat
    var isBold: Bool

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize))
            .foregroundColor(textColorForTheme())
    }

    private func textColorForTheme() -> Color {
        switch colorScheme.getColorScheme() {
        case ColorSchemeMode.Light.title:
            return ThemeColor.lightBlack.color
        case ColorSchemeMode.Dark.title:
            return ThemeColor.lightWhite.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
    }
}

extension View {
    func customNormalTextFont(fontSize: CGFloat, isBold: Bool) -> some View {
        modifier(CustomNormalTextModifier(fontSize: fontSize, isBold: isBold))
    }
}

