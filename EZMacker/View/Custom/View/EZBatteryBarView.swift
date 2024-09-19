//
//  InfoBatteryBarView.swift
//  EZMacker
//
//  Created by 박유경 on 5/26/24.
//

import SwiftUI
import EZMackerUtilLib
struct EZBatteryBarView: View {
    @EnvironmentObject var appThemeManager: AppThemeManager
    @State var isUpdateAnimated  = false
    @Binding var batteryLevel: Double
    @Binding var isAdapterConnected: Bool

    var body: some View {
         GeometryReader { geo in
             HStack(spacing: 0) {
                 if isAdapterConnected {
                     GifRepresentableView(gifName: "battery_charging_animation", imageSize: CGSize(width: 50, height: 50))
                         .frame(width: 70, height: 70)
                 } else {
                     Image(systemName: getBatteryImageName())
                         .resizable()
                         .frame(width: 70, height: 70)
                         .foregroundStyle(batteryImageColors()[0], batteryImageColors()[1])
                 }
                 
                 ZStack(alignment: .leading) {
                     RoundedRectangle(cornerRadius: 2)
                         .fill(ThemeColorType.lightGray.color)
                         .opacity(isUpdateAnimated ? 1.0 : 0.5)
                     
                     RoundedRectangle(cornerRadius: 2)
                         .fill(LinearGradient(gradient: Gradient(colors: gradientColors()), startPoint: .leading, endPoint: .trailing))
                         .frame(width: (geo.size.width - 70) * batteryLevel)
                         .opacity(isUpdateAnimated ? 0.7 : 1.0)
                     
                     Text("\(Int(batteryLevel * 100))%")
                         .foregroundColor(textForegroundColor())
                         .ezNormalTextStyle(fontSize: FontSizeType.small.size, isBold: true)
                         .frame(maxWidth: .infinity, alignment: .center)
                 }
                 .frame(height: 50)
             }
             .frame(width: geo.size.width)
         }
         .onAppear {
             withAnimation(.linear(duration: 1).repeatForever(autoreverses: true)) {
                 if isAdapterConnected {
                     isUpdateAnimated.toggle()
                 }
             }
         }
         .onChange(of: isAdapterConnected) { _, newValue in
             if newValue {
                 withAnimation(.linear(duration: 1).repeatForever(autoreverses: true)) {
                     isUpdateAnimated = true
                 }
             } else {
                 if isUpdateAnimated {
                     withAnimation {
                         isUpdateAnimated = false
                     }
                 }
             }
         }
     }
    
    private func getBatteryImageName() -> String {
        switch batteryLevel {
        case 1:
            return "battery.100percent"
        case 0.66...0.99:
            return "battery.75percent"
        case 0.33...0.65:
            return "battery.50percent"
        case 0.0...0.32:
            return "battery.25percent"
        default:
            Logger.fatalErrorMessage("Unknown Battery Level")
            return ""
        }
    }
    
    private func batteryImageColors() -> [Color] {
        switch appThemeManager.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return [ThemeColorType.lightGreen.color, ThemeColorType.lightGray.color]
        case ColorSchemeModeType.Dark.title:
            return [ThemeColorType.lightGreen.color, ThemeColorType.lightGray.color]
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return [.clear, .clear]
        }
    }
    
    private func textForegroundColor() -> Color {
        switch appThemeManager.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.black.color.opacity(0.5)
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightWhite.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return .clear
        }
    }
    
    private func gradientColors() -> [Color] {
        switch batteryLevel {
        case 1:
            return [ThemeColorType.lightGreen.color, ThemeColorType.lightGreen.color]
        case 0.66...0.99:
            return [ThemeColorType.lightGreen.color.opacity(0.9), ThemeColorType.lightGreen.color.opacity(0.9)]
        case 0.33...0.65:
            return [ThemeColorType.lightGreen.color.opacity(0.7), ThemeColorType.lightGreen.color.opacity(0.7)]
        case 0.0...0.32:
            return [ThemeColorType.lightGreen.color.opacity(0.5), ThemeColorType.lightGreen.color.opacity(0.5)]
        default:
            Logger.fatalErrorMessage("Unknown Battery Level")
        }
        return [.clear, .clear]
    }
}

// #if DEBUG
// struct InfoBatteryBarView_Preview: PreviewProvider {
//    static var previews: some View {
//        @State var isCharging: Bool = false
//        @State var battery: Double = 0.75
//        HStack {
//            InfoBatteryBarView(batteryLevel: $battery, isAdapterConnected: $isCharging)
//        }
//    }
// }
// #endif
