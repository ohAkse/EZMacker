//
//  EZLoadingView.swift
//  EZMacker
//
//  Created by 박유경 on 8/24/24.
//

import SwiftUI
import EZMackerUtilLib

struct EZLoadingView: View {
    @EnvironmentObject var appThemeManager: AppThemeManager
    @State private var isCircleRotating = true
    @State private var animateStart = false
    @State private var animateEnd = true
    
    let size: CGFloat
    let lineWidth: CGFloat
    let text: String
    init(size: CGFloat = 150, lineWidth: CGFloat = 10, text: String = "연결 중...") {
        self.size = size
        self.lineWidth = lineWidth
        self.text = text
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .fill(Color.init(red: 0.96, green: 0.96, blue: 0.96))
                .frame(width: size, height: size)
            Circle()
                .trim(from: animateStart ? 1/3 : 1/9, to: animateEnd ? 2/5 : 1)
                .stroke(lineWidth: lineWidth)
                .rotationEffect(.degrees(isCircleRotating ? 360 : 0))
                .frame(width: size, height: size)
                .foregroundColor(foregroundColorForTheme())
                .onAppear {
                    withAnimation(Animation
                        .linear(duration: 1)
                        .repeatForever(autoreverses: false)) {
                            self.isCircleRotating.toggle()
                        }
                    withAnimation(Animation
                        .linear(duration: 1)
                        .delay(0.5)
                        .repeatForever(autoreverses: true)) {
                            self.animateStart.toggle()
                        }
                    withAnimation(Animation
                        .linear(duration: 1)
                        .delay(1)
                        .repeatForever(autoreverses: true)) {
                            self.animateEnd.toggle()
                        }
                }
            Text(text)
                .padding(.top, size * 0.13)
                .ezNormalTextStyle(fontSize: FontSizeType.small.size, isBold: false)
        }
        .frame(width: size, height: size)
    }

    private func foregroundColorForTheme() -> Color {
        switch appThemeManager.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.cyan.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightGreen.color
        default:
            Logger.fatalErrorMessage("colorScheme is Empty")
            return Color.primary
        }
    }
}
