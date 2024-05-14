//
//  CustomTitle.swift
//  EZMacker
//
//  Created by 박유경 on 5/14/24.
//

import SwiftUI
struct CustomTitle: View {
    @AppStorage(AppStorageKey.colorSchme.name) var colorScheme: String = AppStorageKey.colorSchme.byDefault
    let size: CGFloat = FontSizeType.large.size
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: FontSizeType.superLarge.size))
            .fontWeight(.bold)
            .padding()
            .foregroundColor(getHeaderFontStyles()[0])
            .background(getHeaderFontStyles()[1])
            .clipShape(.capsule(style: .circular))
        
    }
    private func getHeaderFontStyles() -> [Color] {
        switch colorScheme {
        case ColorSchemeMode.Light.title:
            return [ThemeColor.lightGray.color, ThemeColor.lightBlack.color]
        case ColorSchemeMode.Dark.title:
            return [ThemeColor.lightBlack.color, ThemeColor.lightWhite.color]
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return [.clear, .clear]
        }
    }
}
