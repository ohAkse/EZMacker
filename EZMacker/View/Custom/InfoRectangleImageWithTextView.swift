//
//  InfoRectangleView.swift
//  EZMacker
//
//  Created by 박유경 on 5/8/24.
//

import SwiftUI

struct InfoRectangleImageWithTextView: View {
    @AppStorage(AppStorageKey.colorSchme.name) var colorScheme: String = AppStorageKey.colorSchme.byDefault
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
                    .frame(width: geo.size.width * widthScale, height: geo.size.height * heightScale)
                
                VStack(alignment: .center) {
                    Text(title)
                        .bold()
                        .padding(.bottom, 5)
                    Text(info)
                }
                .lineLimit(1)
                .font(.system(size: 30))
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
struct InfoRectangleView_Preview: PreviewProvider {
    static var previews: some View {
        InfoRectangleImageWithTextView(imageName: "thermometer.medium", title: "타잍 ", info: "내용", widthScale:0.3, heightScale:0.7)
    }
}
#endif


