//
//  EZButtonImageStyle.swift
//  EZMacker
//
//  Created by 박유경 on 8/13/24.
//

import SwiftUI
import EZMackerUtilLib

struct EZButtonImageStyle: ButtonStyle {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    
    let imageSize: CGSize
    let imageName: String
    let isSystemImage: Bool
    let lightModeForegroundColor: Color
    let darkModeForegroundColor: Color
    let lightModeBackgroundColor: Color?
    let darkModeBackgroundColor: Color?
    let frameSize: CGSize?
    let isAddButton: Bool

    func makeBody(configuration: Configuration) -> some View {
        Group {
            if isSystemImage {
                Image(systemName: imageName)
                    .resizable()
            } else {
                Image(imageName)
                    .resizable()
            }
        }
        .aspectRatio(contentMode: .fit)
        .frame(width: imageSize.width, height: imageSize.height)
        .foregroundColor(foregroundColorForTheme())
        .padding()
        .background(backgroundColorForTheme())
        .frame(width: frameSize?.width, height: frameSize?.height)
        .cornerRadius(frameSize != nil ? min(frameSize!.width, frameSize!.height) / 4 : 0)
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
        .buttonStyle(PlainButtonStyle())
    }
    
    private func foregroundColorForTheme() -> Color {
        switch colorSchemeViewModel.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return lightModeForegroundColor
        case ColorSchemeModeType.Dark.title:
            return darkModeForegroundColor
        default:
            Logger.fatalErrorMessage("colorScheme is Empty")
            return Color.primary
        }
    }

    private func backgroundColorForTheme() -> Color? {
        switch colorSchemeViewModel.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return lightModeBackgroundColor
        case ColorSchemeModeType.Dark.title:
            return darkModeBackgroundColor
        default:
            Logger.fatalErrorMessage("colorScheme is Empty")
            return Color.clear
        }
    }
}

extension View {
    func ezButtonImageStyle(
        imageName: String,
        isSystemImage: Bool = true,
        imageSize: CGSize = CGSize(width: 15, height: 15),
        lightModeForegroundColor: Color = ThemeColorType.lightDark.color,
        darkModeForegroundColor: Color = ThemeColorType.white.color,
        lightModeBackgroundColor: Color? = ThemeColorType.white.color.opacity(0.4),
        darkModeBackgroundColor: Color? = ThemeColorType.white.color.opacity(0.4),
        frameSize: CGSize? = CGSize(width: 30, height: 30),
        isAddButton: Bool = false
    ) -> some View {
        self.buttonStyle(EZButtonImageStyle(
            imageSize: imageSize,
            imageName: imageName,
            isSystemImage: isSystemImage,
            lightModeForegroundColor: lightModeForegroundColor,
            darkModeForegroundColor: darkModeForegroundColor,
            lightModeBackgroundColor: lightModeBackgroundColor,
            darkModeBackgroundColor: darkModeBackgroundColor,
            frameSize: frameSize,
            isAddButton: isAddButton
        ))
    }
}

// struct EZButtonImageStyle: ButtonStyle {
//    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
//    
//    var imageSize: CGSize
//    var imageName: String
//    var isSystemImage: Bool
//    var foregroundColor: Color
//    var backgroundColor: Color?
//    var frameSize: CGSize?
//
//    func makeBody(configuration: Configuration) -> some View {
//        Group {
//            if isSystemImage {
//                Image(systemName: imageName)
//                    .resizable()
//            } else {
//                Image(imageName)
//                    .resizable()
//            }
//        }
//        .aspectRatio(contentMode: .fit)
//        .frame(width: imageSize.width, height: imageSize.height)
//        .foregroundColor(dynamicForegroundColor)
//        .background(dynamicBackgroundColor)
//        .padding()
//        .frame(width: frameSize?.width, height: frameSize?.height)
//        .cornerRadius(frameSize != nil ? min(frameSize!.width, frameSize!.height) / 4 : 0)
//        .scaleEffect(configuration.isPressed ? 0.95 : 1)
//        .buttonStyle(PlainButtonStyle())
//    }
//    
//    private var dynamicForegroundColor: Color {
//        switch colorSchemeViewModel.getColorScheme() {
//        case ColorSchemeModeType.Light.title:
//            return foregroundColor
//        case ColorSchemeModeType.Dark.title:
//            return foregroundColor.opacity(0.8)
//        default:
//            Logger.fatalErrorMessage("colorScheme is Empty")
//            return Color.primary
//        }
//    }
//
//    private var dynamicBackgroundColor: Color? {
//        guard let backgroundColor = backgroundColor else { return nil }
//        switch colorSchemeViewModel.getColorScheme() {
//        case ColorSchemeModeType.Light.title:
//            return backgroundColor
//        case ColorSchemeModeType.Dark.title:
//            return backgroundColor.opacity(0.7)
//        default:
//            Logger.fatalErrorMessage("colorScheme is Empty")
//            return Color.clear
//        }
//    }
// }
//
// extension View {
//    func ezButtonImageStyle(
//        imageName: String,
//        isSystemImage: Bool = true,
//        imageSize: CGSize = CGSize(width: 30, height: 30),
//        foregroundColor: Color = .blue,
//        backgroundColor: Color? = nil,
//        frameSize: CGSize? = nil
//    ) -> some View {
//        self.buttonStyle(EZButtonImageStyle(
//            imageSize: imageSize,
//            imageName: imageName,
//            isSystemImage: isSystemImage,
//            foregroundColor: foregroundColor,
//            backgroundColor: backgroundColor,
//            frameSize: frameSize
//        ))
//    }
// }
