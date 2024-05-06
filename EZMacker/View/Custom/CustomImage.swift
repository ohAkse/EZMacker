//
//  CustomImage.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import SwiftUI
struct CustomImageModifier: ViewModifier {
    @AppStorage(AppStorageKey.colorSchme.name) var colorScheme: String  = AppStorageKey.colorSchme.byDefault
    var imageScale: Image.Scale
    func body(content: Content) -> some View {
        content
            .imageScale(imageScale)
            .foregroundColor(imageColorForTheme())
    }
    
    private func imageColorForTheme() -> Color {
        switch colorScheme {
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
    func customImage(imageScale: Image.Scale) -> some View {
        modifier(CustomImageModifier(imageScale: imageScale))
    }
}
