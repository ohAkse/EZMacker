//
//  InfoRectangleHImageTextView.swift
//  EZMacker
//
//  Created by 박유경 on 5/14/24.
//

import SwiftUI

struct InfoRectangleHImageTextView: View {
    @AppStorage(AppStorageKey.colorSchme.name) var colorScheme: String = AppStorageKey.colorSchme.byDefault
    @State private var isAnimated = false
    let imageName: String
    let title: String
    let info: String
    let widthScale: CGFloat
    let heightScale: CGFloat
    var body: some View {
        GeometryReader { geo in
            HStack(alignment:.center, spacing: 5) {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.red, Color.blue)
                    .padding(20)
                    .animation(.easeIn(duration: 3),value:isAnimated)
                Spacer()
                VStack(alignment: .center) {
                    
                        Text(title)
                            .bold()
                            .padding(.bottom, 5)
                            .font(.system(size: 30))
                    if isAnimated {
                        Text(info)
                            .foregroundStyle(colorForHealthState(healthState: info))
                            .font(.system(size: 20))
                    }
                }
                .onAppear{
                    withAnimation(.easeIn(duration: 0.5)) {
                        isAnimated.toggle()
                    }
                }
                .onDisappear{
                    withAnimation(.easeIn(duration: 0.2)) {
                        isAnimated.toggle()
                    }
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity , maxHeight: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(cardColorForTheme())
            }
        }
        .padding(.vertical)
        .shadow(radius: 5)
        
    }
    
    func colorForHealthState(healthState: String) -> Color {
        
        switch healthState {
        case "Good":
            return ThemeColor.lightGreen.color
        case "Normal":
            return ThemeColor.lightYellow.color
        case "Bad":
            return ThemeColor.lightRed.color
        default:
            return ThemeColor.lightBlack.color
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
struct InfoRectangleHImageTextView_PreView: PreviewProvider {
    static var previews: some View {
        InfoRectangleHImageTextView(imageName: "thermometer.medium", title: "타잍 ", info: "내용", widthScale:0.3, heightScale:0.7)
    }
}
#endif



