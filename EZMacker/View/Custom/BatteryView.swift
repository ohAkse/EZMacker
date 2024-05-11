//
//  BatteryView.swift
//  EZMacker
//
//  Created by 박유경 on 5/8/24.
//

import SwiftUI

struct BatteryView: View {
    @AppStorage(AppStorageKey.colorSchme.name) var colorScheme: String = AppStorageKey.colorSchme.byDefault
    let batteryLevel: Int
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                HStack(spacing: 10) {
                    Image(systemName: "battery.100.bolt")
                        .resizable()
                        .frame(width: 70, height: 60)
                        .foregroundStyle(batteryImageColors()[0], batteryImageColors()[1])
                    RoundedRectangle(cornerRadius: 5)
                        .fill(LinearGradient(gradient: Gradient(colors: gradientColors()), startPoint: .leading, endPoint: .trailing))
                        .frame(width: max(0, (geo.size.width * CGFloat(batteryLevel)) / 100 - 80), height: 60)
                }
            }
        }
    }
    
    private func batteryImageColors() -> [Color] {
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
    
    private func gradientColors() -> [Color] {
        switch colorScheme {
        case ColorSchemeMode.Light.title:
            return [.blue.opacity(0.1), .blue.opacity(0.99)]
        case ColorSchemeMode.Dark.title:
            return [.green.opacity(0.1), .green.opacity(0.99)]
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return [.clear, .clear]
        }
    }
}



#Preview {
    BatteryView(batteryLevel: 75)
}
