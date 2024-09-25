//
//  ToastView.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import SwiftUI

struct ToastView: View {
    @EnvironmentObject var appThemeManager: SystemThemeService
    var type: ToastType
    var title: String
    var message: String
    var onCancelTapped: (() -> Void)
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(systemName: type.iconFileName)
                    .foregroundColor(type.themeColor)
                
                VStack(alignment: .leading) {
                    Text(type.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(appThemeManager.getColorScheme() == ColorSchemeModeType.Light.title ? ThemeColorType.lightBlack.color : ThemeColorType.lightBlack.color)
                    
                    Text(message)
                        .font(.system(size: 12))
                        .foregroundColor(appThemeManager.getColorScheme() == ColorSchemeModeType.Light.title ? ThemeColorType.lightBlack.color : ThemeColorType.lightBlack.color)
                }
                
                Spacer(minLength: 10)
                
                Button {
                    onCancelTapped()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(Color.black)
                }
            }
            .padding()
        }
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(type.themeColor)
                .frame(width: 6)
                .clipped()
            , alignment: .leading
        )
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
        .padding(.horizontal, 16)
    }
}
struct ToastModifier: ViewModifier {
    @Binding var toast: ToastData?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                }.animation(.spring(), value: toast)
            )
            .onChange(of: toast) {
                showToast()
            }
    }
    
    @ViewBuilder func mainToastView() -> some View {
        if let toast = toast {
            VStack {
                Spacer()
                ToastView(
                    type: toast.type,
                    title: toast.type.title,
                    message: toast.message) {
                        dismissToast()
                    }
            }
            .transition(.move(edge: .bottom))
        }
    }
        
    private func showToast() {
        guard let toast = toast else { return }
        
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
               dismissToast()
            }
            
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        workItem?.cancel()
        workItem = nil
    }
}
