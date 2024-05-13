//
//  InfoRectangleTextView.swift
//  EZMacker
//
//  Created by 박유경 on 5/12/24.
//

import SwiftUI

struct InfoRectangleTextView: View {
    @AppStorage(AppStorageKey.colorSchme.name) var colorScheme: String = AppStorageKey.colorSchme.byDefault
    let header: String
    let content: String
    var body: some View {
        VStack {
            Text(header)
                .customText(fontSize: FontSizeType.superLarge.size, isBold: true)
            Spacer()
            Text(content)
                .font(.system(size: FontSizeType.large.size))
                .foregroundStyle(colorForHealthState(healthState: content))
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 90)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(cardColorForTheme())
        }
        .cornerRadius(15)
        .shadow(radius: 5)
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
}


struct InfoRectangleTextView_Preview: PreviewProvider {
    static var previews: some View {
        InfoRectangleTextView(header: "헤더", content: "내용")
             .frame(width: 300, height: 200)
    }
}
