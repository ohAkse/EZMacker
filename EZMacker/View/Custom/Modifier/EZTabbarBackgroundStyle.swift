//
//  EZTabbarBackgroundStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/12/24.
//

import SwiftUI

struct EZTabbarBackgroundStyle: ViewModifier {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel

    func body(content: Content) -> some View {
        content
            .background(backgroundColor())
    }

    private func backgroundColor() -> Color {
        switch colorSchemeViewModel.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightGreen.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightRed.color
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
