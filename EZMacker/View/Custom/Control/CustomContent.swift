//
//  CustomContent.swift
//  EZMacker
//
//  Created by 박유경 on 5/14/24.
//

import SwiftUI
struct CustomContent: View {
    @AppStorage(AppStorageKey.colorSchme.name) var colorScheme: String = AppStorageKey.colorSchme.byDefault
    let size: CGFloat = FontSizeType.large.size
    let content: String
    
    var body: some View {
        Text(content)
            .font(.system(size: FontSizeType.large.size))
            .foregroundColor(getContentFontStyles())
        
    }
    private func getContentFontStyles() -> Color {
        switch colorScheme {
        case ColorSchemeMode.Light.title:
            return ThemeColor.lightWhite.color
        case ColorSchemeMode.Dark.title:
            return ThemeColor.lightBlue.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return .clear
        }
    }
}

