//
//  InfoElipseHImageView.swift
//  EZMacker
//
//  Created by 박유경 on 5/14/24.
//

import SwiftUI

struct InfoElipseHImageView: View {
    @AppStorage(AppStorageKey.colorSchme.name) var colorScheme: String = AppStorageKey.colorSchme.byDefault
    let size: CGFloat = FontSizeType.large.size
    let title: String
    let content: String
    @State var isAdapterAnimated = false
    var body: some View {
        
        HStack {
            if isAdapterAnimated{
                CustomTitle(title: title)
                Spacer()
                HStack {
                    CustomContent(content: content)
                }
                .padding(.trailing, 10)
                Spacer()
            }
        }
        .background(ThemeColor.lightBlue.color.opacity(0.7))
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
        switch colorScheme {
        case ColorSchemeMode.Light.title:
            return ThemeColor.lightGray.color
        case ColorSchemeMode.Dark.title:
            return ThemeColor.lightGray.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return ThemeColor.lightGray.color
        }
    }
    
    private func cardColorForTheme() -> Color {
        switch colorScheme {
        case ColorSchemeMode.Light.title:
            return ThemeColor.lightGray.color
        case ColorSchemeMode.Dark.title:
            return ThemeColor.lightBlue.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
    }
}

#if DEBUG
struct InfoElipseHImageView_Preview: PreviewProvider {
    static var previews: some View {
        HStack {
            InfoElipseHImageView(title: "DD", content: "SS")
        }
    }
}
#endif
