//
//  CustomFont.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import SwiftUI
struct CustomTextModifier: ViewModifier {
    @AppStorage(AppStorageKey.colorSchme.name) var colorScheme: String  = AppStorageKey.colorSchme.byDefault
    var fontSize: CGFloat
    var isBold: Bool

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize))
            .foregroundColor(textColorForTheme())
    }

    private func textColorForTheme() -> Color {
        switch colorScheme {
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
    func customFont1(fontSize: CGFloat, isBold: Bool) -> some View {
        modifier(CustomTextModifier(fontSize: fontSize, isBold: isBold))
    }
}

