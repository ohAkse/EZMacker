//
//  AlertInfoView.swift
//  EZMacker
//
//  Created by 박유경 on 6/15/24.
//

import SwiftUI
import EZMackerUtilLib

struct AlertOKCancleView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var systemThemeService: SystemThemeService
    var title: String
    var subtitle: String
    var content: String
    var onOk: (() -> Void)?
    
    var body: some View {
        VStack {
            HStack {
                Image("alert_icon")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.trailing, 10)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.subheadline)
                }
            }
            Text(content)
                .padding()
            HStack {
                Button(action: {
                    isPresented = false
                }, label: {
                    Text("취소")
                        .ezNormalTextStyle(fontSize: FontSizeType.extrasmall.size, isBold: false)
                })
                .frame(width: 60, height: 20)
                Spacer()
                Button(action: {
                    isPresented = false
                    onOk?()
                }, label: {
                    Text("확인")
                        .ezNormalTextStyle(fontSize: FontSizeType.extrasmall.size, isBold: false)
                })
                .frame(width: 60, height: 20)
            }
        }
        .padding()
        .background(backgroundColorForTheme())
        .cornerRadius(8)
        .shadow(radius: 10)
        .frame(width: 300)
    }
    
    private func backgroundColorForTheme() -> Color {
        switch systemThemeService.getColorScheme() {
        case ColorSchemeModeType.Light.title:
            return ThemeColorType.lightGray.color
        case ColorSchemeModeType.Dark.title:
            return ThemeColorType.lightDark.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
    }
}
