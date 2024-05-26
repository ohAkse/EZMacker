//
//  CustomTitle.swift
//  EZMacker
//
//  Created by 박유경 on 5/14/24.
//

import SwiftUI
struct CustomTitle: View {
    @EnvironmentObject var colorScheme: ColorSchemeViewModel
    let size: CGFloat = FontSizeType.large.size
    let title: String
    
    
    var body: some View {
        Text(title)
            .frame(width: 120, height: 50)
            .font(.system(size: FontSizeType.medium.size))
            .fontWeight(.bold)
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .foregroundColor(getHeaderFontStyles()[0])
            .background(getHeaderFontStyles()[1])
            .clipShape(.capsule(style: .circular))
            .lineLimit(2)
            .shadow(radius: 5)
    }
    private func getHeaderFontStyles() -> [Color] {
        switch colorScheme.getColorScheme() {
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
