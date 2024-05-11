//
//  CustomImage.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import SwiftUI
struct CustomImageModifier: ViewModifier {
    @AppStorage(AppStorageKey.colorSchme.name) var colorScheme: String  = AppStorageKey.colorSchme.byDefault
    var imageScale: Image.Scale
    var width: CGFloat
    var height: CGFloat
    func body(content: Content) -> some View {
        content
            .frame(width: width, height: height)
            .imageScale(imageScale)
            .foregroundColor(imageColorForTheme())
    }
    
    private func imageColorForTheme() -> Color {
        switch colorScheme {
        case ColorSchemeMode.Light.title:
            return ThemeColor.lightBlue.color
        case ColorSchemeMode.Dark.title:
            return ThemeColor.lightGreen.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
    }
}

extension View {
    func customImage(imageScale: Image.Scale, width: CGFloat, height: CGFloat) -> some View {
        modifier(CustomImageModifier(imageScale: imageScale, width: width, height: height))
    }
}


struct CircularBorderModifier: ViewModifier {
    @AppStorage(AppStorageKey.colorSchme.name) var colorScheme: String  = AppStorageKey.colorSchme.byDefault
    var width: CGFloat
    var height: CGFloat

    func body(content: Content) -> some View {
        ZStack {
            content
            RoundedRectangle(cornerRadius: 8)
                .stroke(imageColorForTheme(), lineWidth: 2)
                .frame(width: width, height: height)
        }
    }
    
    private func imageColorForTheme() -> Color {
        switch colorScheme {
        case ColorSchemeMode.Light.title:
            return ThemeColor.lightBlue.color
        case ColorSchemeMode.Dark.title:
            return ThemeColor.lightGreen.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
    }
}

extension View {
    func circularBorder(width: CGFloat, height: CGFloat) -> some View {
        self.modifier(CircularBorderModifier(width: width, height: height))
    }
}

struct CustomHStackWithCircularBorderModifier: ViewModifier {
    @AppStorage(AppStorageKey.colorSchme.name) var colorScheme: String = AppStorageKey.colorSchme.byDefault
    let imageName: String
    let labelText: String
    let imageWidth: CGFloat
    let imageHeight: CGFloat
    var width: CGFloat
    var height: CGFloat

    func body(content: Content) -> some View {
        ZStack {
            content
                .padding(4)
                .background(borderForTheme()) // 네모난 사각형 배경 추가
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .frame(width: imageWidth, height: imageHeight)
                Text(labelText)
                    .customText(fontSize: FontSizeType.large.size, isBold: false)
            }
        }
        .background(Color.red) // 기본 배경 추가
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(imageColorForTheme(), lineWidth: 3)
                .background(Color.clear) // 테두리 배경은 투명하게
        )
        .clipped() // 경로를 벗어난 부분 자르기
    }

    private func borderForTheme() -> Color {
        switch colorScheme {
        case ColorSchemeMode.Light.title:
            return ThemeColor.lightGray.color
        case ColorSchemeMode.Dark.title:
            return ThemeColor.lightGreen.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
    }
    
    private func imageColorForTheme() -> Color {
        switch colorScheme {
        case ColorSchemeMode.Light.title:
            return ThemeColor.lightBlue.color
        case ColorSchemeMode.Dark.title:
            return ThemeColor.lightGreen.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
    }
}





