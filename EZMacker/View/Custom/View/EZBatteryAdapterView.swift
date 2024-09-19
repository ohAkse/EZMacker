//
//  EZBatteryAdapterView.swift
//  EZMacker
//
//  Created by 박유경 on 8/17/24.
//

import SwiftUI
import EZMackerUtilLib

struct EZBatteryAdapterView: View {
    @EnvironmentObject var colorScheme: AppToolbarViewModel
    let size: CGFloat = FontSizeType.medium.size
    let title: String
    let content: String
    @State var isAdapterAnimated = false
    var body: some View {
        HStack {
            if isAdapterAnimated {
                EZTitle(title: title)
                Spacer()
                EZContent(content: content)
                    .padding(.trailing, 10)
                Spacer()
            }
        }
        .background(backgroundColorForTheme())
        .clipShape(.capsule)
        .onAppear {
            withAnimation(.spring(duration: 0.2)) {
                isAdapterAnimated.toggle()
            }
        }
        .onDisappear {
            withAnimation(.interactiveSpring(duration: 0.2)) {
                isAdapterAnimated.toggle()
           }
        }
        .padding(5)
    }
    
    private func backgroundColorForTheme() -> Color {
        switch colorScheme.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.white.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.softWhite.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
    }
}

// #if DEBUG
// struct EZElipseHImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        EZElipseHImageView(title: "Title", content: "Content")
//            .environmentObject(ColorSchemeViewModel())
//    }
// }
// #endif
