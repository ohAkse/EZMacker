//
//  BatteryView.swift
//  EZMacker
//
//  Created by 박유경 on 5/8/24.
//

import SwiftUI

struct BatteryBarView: View {
    @AppStorage(AppStorageKey.colorSchme.name) var colorScheme: String = AppStorageKey.colorSchme.byDefault
    @State var isUpdateAnimated  = false
    let batteryLevel: Double
    @Binding var isAdapterConnected : Bool
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Image(systemName: getBatteryImageName())
                        .resizable()
                        .frame(width: 70, height: 60)
                        .foregroundStyle(batteryImageColors()[0], batteryImageColors()[1])
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(LinearGradient(gradient: Gradient(colors: gradientColors()), startPoint: .leading, endPoint: .trailing))
                            .frame(width: max(0, geo.size.width * batteryLevel - 70), height: 60)
                            .padding(0)
                            .opacity(isUpdateAnimated ? 0.7 : 1.0)
                        Text("\(Int(batteryLevel * 100))%")
                            .foregroundColor(ThemeColor.lightGray.color)
                            .padding(.horizontal, 5)
                    }
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(ThemeColor.lightGray.color)
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
        switch batteryLevel {
        case 1:
            return  "battery.100percent"
        case 0.75...0.99:
            return  "battery.75percent"
        case 0.5...0.74:
            return  "battery.50percent"
        case 0.25...0.49:
            return  "battery.25percent"
        case 0...0.24:
            return "battery.0percent"
        default:
            Logger.fatalErrorMessage("Unknown Battery Level")
        }
        return ""
    }
    
    private func batteryImageColors() -> [Color] {
        switch colorScheme {
        case ColorSchemeMode.Light.title:
            return [.blue, .yellow]
        case ColorSchemeMode.Dark.title:
            return [.yellow, .green]
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return [.clear, .clear]
        }
    }
    
    private func gradientColors() -> [Color] {
        switch batteryLevel {
        case 1:
            return [ThemeColor.lightBlue.color.opacity(0.7), ThemeColor.lightBlue.color.opacity(0.99)]
        case 0.66...0.99:
            return [ThemeColor.lightGreen.color.opacity(0.7), ThemeColor.lightGreen.color.opacity(0.99)]
        case 0.33...0.65:
            return [ThemeColor.lightYellow.color.opacity(0.7), ThemeColor.lightYellow.color.opacity(0.99)]
        case 0.01...0.32:
            return [ThemeColor.lightRed.color.opacity(0.7), ThemeColor.lightRed.color.opacity(0.99)]
        default:
            Logger.fatalErrorMessage("Unknown Battery Level")
        }
        return [.clear, .clear]
    }
}

#if DEBUG
struct BatteryBarView_Preview: PreviewProvider {
    static var previews: some View {
        @State var isCharging: Bool = false
        HStack {
            BatteryBarView(batteryLevel: 0.75, isAdapterConnected: $isCharging)
        }
    }
}
#endif


