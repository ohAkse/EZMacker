//
//  EZImageView.swift
//  EZMacker
//
//  Created by 박유경 on 10/6/24.
//

import SwiftUI
import EZMackerUtilLib

struct EZImageView: View {
    @EnvironmentObject var systemThemeService: SystemThemeService
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
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
    
    private func getImage() -> Image {
        return isSystemName ? Image(systemName: systemName) : Image(systemName)
    }
    
    private func getImageForegroundStyle() -> [Color] {
        switch systemThemeService.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return [.gray, .blue]
        case ColorSchemeModeType.Dark.title:
            return [.yellow, .green]
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return [.clear, .clear]
        }
    }
    private func getImageBackground() -> Color {
        switch systemThemeService.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightWhite.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightGray.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return .clear
        }
    }
}
