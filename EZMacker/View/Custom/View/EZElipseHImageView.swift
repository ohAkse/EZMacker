//
//  InfoElipseHImageView.swift
//  EZMacker
//
//  Created by 박유경 on 5/14/24.
//

import SwiftUI

struct EZElipseHImageView: View {
    @EnvironmentObject var colorScheme: ColorSchemeViewModel
    let size: CGFloat = FontSizeType.large.size
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
        .background(ThemeColorType.lightBlue.color.opacity(0.7))
        .clipShape(.ellipse)
        .border(getBorderColor(), width: 2)
        .onAppear{
            withAnimation(.spring(duration: 0.2)) {
                isAdapterAnimated.toggle()
            }
        }
        .onDisappear{
            withAnimation(.interactiveSpring(duration: 0.2)) {
                isAdapterAnimated.toggle()
           }
        }
    }
    private func getBorderColor() -> Color {
        switch colorScheme.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightGray.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightGray.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return ThemeColorType.lightGray.color
        }
    }
    
    private func cardColorForTheme() -> Color {
        switch colorScheme.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightGray.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightBlue.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
    }
}

//#if DEBUG
//struct InfoElipseHImageView_Preview: PreviewProvider {
//    static var previews: some View {
//        HStack {
//            InfoElipseHImageView(title: "DD", content: "SS")
//        }
//    }
//}
//#endif
