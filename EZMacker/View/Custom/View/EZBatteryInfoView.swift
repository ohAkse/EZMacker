//
//  InfoRectangleHImageTextView.swift
//  EZMacker
//
//  Created by 박유경 on 5/14/24.
//

import SwiftUI
import EZMackerUtilLib

struct EZBatteryInfoView: View {
    
    @EnvironmentObject var colorScheme: AppToolbarViewModel
    @State private var isAnimated = false
    let imageName: String
    let isSystem: Bool
    let title: String
    let info: String
    let isBatterStatus: Bool 
    
    init(imageName: String, isSystem: Bool, title: String, info: String, isBatterStatus: Bool = false) {
        self.imageName = imageName
        self.isSystem = isSystem
        self.title = title
        self.info = info
        self.isBatterStatus = isBatterStatus
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .center, spacing: 5) {
                    getImage()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.75)
                    .symbolRenderingMode(.palette)
                    .padding(10)
                    .animation(.easeIn(duration: 3), value: isAnimated)
                Spacer(minLength: 5)
                VStack(alignment: .center) {
                        Text(title)
                            .bold()
                            .padding(.bottom, 5)
                            .foregroundStyle(titleTextColor())
                            .font(.system(size: FontSizeType.large.size))
                    if isAnimated {
                        if isBatterStatus {
                            Text(info)
                                .foregroundStyle(colorForHealthState(healthState: info))
                                .font(.system(size: FontSizeType.medium.size))
                        } else {
                            Text(info)
                                .foregroundStyle(contentTextColor())
                                .font(.system(size: FontSizeType.medium.size))
                        }
                    }
                }
                .onAppear {
                    withAnimation(.interactiveSpring(duration: 0.5)) {
                        isAnimated.toggle()
                    }
                }
                .onDisappear {
                    withAnimation(.interactiveSpring(duration: 0.5)) {
                        isAnimated.toggle()
                    }
                }
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(foregroundColorForTheme())
            }
        }
        .padding(.vertical)
    }
    private func getImage() -> Image {
        return isSystem ? Image(systemName: imageName) : Image(imageName)
    }
    
    private func colorForHealthState(healthState: String) -> Color {
        switch healthState {
        case "Good":
            return ThemeColorType.lightGreen.color
        case "Normal":
            return ThemeColorType.lightYellow.color
        case "Bad":
            return ThemeColorType.lightRed.color
        default:
            return ThemeColorType.lightBlack.color
        }
    }
    
    private func titleTextColor() -> Color {
        switch colorScheme.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.black.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightWhite.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
    }
    
    private func contentTextColor() -> Color {
        switch colorScheme.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.black.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightWhite.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
    }
    
    private func foregroundColorForTheme() -> Color {
        switch colorScheme.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightGray.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightDark.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
    }
}
