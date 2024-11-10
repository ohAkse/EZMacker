//
//  EZButtonImageStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/13/24.
//

import SwiftUI
import EZMackerUtilLib

enum ButtonImageType {
    case basic
    case clear
    case custom
    case tabAdd
}

struct EZButtonImageStyle: ButtonStyle {
    @EnvironmentObject var systemThemeService: SystemThemeService
    
    let type: ButtonImageType
    let imageName: String
    let imageSize: CGSize
    let frameSize: CGSize?
    
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: imageSize.width, height: imageSize.height)
            .foregroundColor(getForegroundColor())
            .padding()
            .background(getBackgroundColor())
            .frame(width: frameSize?.width, height: frameSize?.height)
            .cornerRadius(frameSize.map { min($0.width, $0.height) / 4 } ?? 0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
    
    private func getForegroundColor() -> Color {
        let isLight = systemThemeService.getColorScheme() == ColorSchemeModeType.Light.title
        
        switch type {
        case .basic:
            return isLight ? ThemeColorType.lightBlack.color : ThemeColorType.lightWhite.color
        case .clear:
            return isLight ? ThemeColorType.orange.color : ThemeColorType.orange.color
        case .custom:
            return isLight ? ThemeColorType.cyan.color : ThemeColorType.cyan.color
        case .tabAdd:
            return isLight ? ThemeColorType.lightBlue.color : ThemeColorType.cyan.color
        }
    }
    
    private func getBackgroundColor() -> Color {
        let isLight = systemThemeService.getColorScheme() == ColorSchemeModeType.Light.title
        
        switch type {
        case .basic:
            return isLight ? ThemeColorType.lightWhite.color : ThemeColorType.lightDark.color
        case .clear, .custom, .tabAdd:
            return .clear
        }
    }
}

extension View {
    func ezButtonImageStyle(
        type: ButtonImageType = .basic,
        imageName: String,
        imageSize: CGSize = CGSize(width: 20, height: 20),
        frameSize: CGSize? = nil
    ) -> some View {
        self.buttonStyle(EZButtonImageStyle(
            type: type,
            imageName: imageName,
            imageSize: imageSize,
            frameSize: frameSize
        ))
    }
}
