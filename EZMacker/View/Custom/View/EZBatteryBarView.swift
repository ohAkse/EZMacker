//
//  InfoBatteryBarView.swift
//  EZMacker
//
//  Created by 박유경 on 5/26/24.
//

import SwiftUI
struct EZBatteryBarView: View {
    @EnvironmentObject var colorScheme: ColorSchemeViewModel
    @State var isUpdateAnimated  = false
    @Binding var batteryLevel: Double
    @Binding var isAdapterConnected : Bool
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
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
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(LinearGradient(gradient: Gradient(colors: gradientColors()), startPoint: .leading, endPoint: .trailing))
                            .frame(width: max(0, geo.size.width * batteryLevel - 70), height: 60)
                            .padding(0)
                            .opacity(isUpdateAnimated ? 0.7 : 1.0)
                        Text("\(Int(batteryLevel * 100))%")
                            .foregroundColor(ThemeColorType.lightGray.color)
                            .padding(.horizontal, 5)
                    }
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(ThemeColorType.lightGray.color)
                        .opacity(isUpdateAnimated ? 1.0 : 0.5)
                        .frame(width: max(0, geo.size.width * (1 - batteryLevel)), height: 60)
                        .padding(0)
                        .offset(x: -2) //충전색 네모 모서리랑 겹치게 하기위해..
                }
                .padding(0)
                .frame(width: geo.size.width * 1.0)
                .onAppear {
                    withAnimation(.linear(duration: 1).repeatForever(autoreverses: true)) {
                        if isAdapterConnected {
                            isUpdateAnimated.toggle()
                        }
                    }
                }
                .onChange(of: isAdapterConnected) { oldValue, newValue in
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
        }
    }
    
    //TODO: 충전용 gif이미지 구현하는방법..?
    private func getBatteryImageName() -> String {
        return "battery.100percent"
    }
    
    private func batteryImageColors() -> [Color] {
        switch colorScheme.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return [ThemeColorType.lightGreen.color, ThemeColorType.lightGray.color]
        case ColorSchemeModeType.Dark.title:
            return [ThemeColorType.lightBlue.color, ThemeColorType.lightGray.color]
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return [.clear, .clear]
        }
    }
    
    private func gradientColors() -> [Color] {
        switch batteryLevel {
        case 1:
            return [ThemeColorType.lightBlue.color.opacity(0.7), ThemeColorType.lightBlue.color.opacity(0.99)]
        case 0.66...0.99:
            return [ThemeColorType.lightGreen.color.opacity(0.7), ThemeColorType.lightGreen.color.opacity(0.99)]
        case 0.33...0.65:
            return [ThemeColorType.lightYellow.color.opacity(0.7), ThemeColorType.lightYellow.color.opacity(0.99)]
        case 0.0...0.32:
            return [ThemeColorType.lightRed.color.opacity(0.7), ThemeColorType.lightRed.color.opacity(0.99)]
        default:
            Logger.fatalErrorMessage("Unknown Battery Level")
        }
        return [.clear, .clear]
    }
}

//#if DEBUG
//struct InfoBatteryBarView_Preview: PreviewProvider {
//    static var previews: some View {
//        @State var isCharging: Bool = false
//        @State var battery: Double = 0.75
//        HStack {
//            InfoBatteryBarView(batteryLevel: $battery, isAdapterConnected: $isCharging)
//        }
//    }
//}
//#endif

