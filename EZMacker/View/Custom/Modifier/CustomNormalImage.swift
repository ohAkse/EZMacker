//
//  CustomNormalImage.swift
//  EZMacker
//
//  Created by 박유경 on 5/14/24.
//

import SwiftUI
struct CustomNormalImageModifier: ViewModifier {
    @EnvironmentObject var colorScheme: ColorSchemeViewModel
    var imageScale: Image.Scale
    var width: CGFloat
    var height: CGFloat
    func body(content: Content) -> some View {
        content
            .frame(width: width, height: height)
            .imageScale(imageScale)
            .foregroundColor(imageColorForTheme())
    }
    
    private func imageColorForTheme() -> Color {
        switch colorScheme.getColorScheme() {
        case ColorSchemeMode.Light.title:
            return ThemeColor.lightBlue.color
        case ColorSchemeMode.Dark.title:
            return ThemeColor.lightGreen.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
    }
}

extension View {
    func customNormalImage(imageScale: Image.Scale, width: CGFloat, height: CGFloat) -> some View {
        modifier(CustomNormalImageModifier(imageScale: imageScale, width: width, height: height))
    }
}



