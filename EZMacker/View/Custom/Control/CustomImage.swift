//
//  CustomImage.swift
//  EZMacker
//
//  Created by 박유경 on 5/14/24.
//

import SwiftUI

struct CustomImage: View {
    @AppStorage(AppStorageKey.colorSchme.name) var colorScheme: String = AppStorageKey.colorSchme.byDefault
    let systemName: String
    let isSystemName: Bool
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 0) {
                    getImage()
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(getImageForegroundStyle()[0], getImageForegroundStyle()[1])
                    .background(Color.clear)
                    .padding(5)
                    .frame(width:geo.size.width, height: geo.size.height)
            }
        }
    }
    
    private func getImage() -> Image {
        return isSystemName ? Image(systemName: systemName) : Image(systemName)
    }
    
    private func getImageForegroundStyle() -> [Color] {
        switch colorScheme {
        case ColorSchemeMode.Light.title:
            return [.gray, .blue]
        case ColorSchemeMode.Dark.title:
            return [.yellow, .green]
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return [.clear, .clear]
        }
    }
    private func getImageBackground() -> Color {
        switch colorScheme {
        case ColorSchemeMode.Light.title:
            return ThemeColor.lightWhite.color
        case ColorSchemeMode.Dark.title:
            return .clear
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return .clear
        }
    }
}

#if DEBUG
struct CustomImage_Preview: PreviewProvider {
    static var previews: some View {
        CustomImage(systemName: "globe", isSystemName: true)
    }
}
#endif
