//
//  SmartBatteryView.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import SwiftUI
struct SmartBatteryView: View {
    @ObservedObject var smartBatteryViewModel: SmartBatteryViewModel
    @State private var toast: Toast?
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .customImage(imageScale: .large)
                .onTapGesture {
                    toast = Toast(type: .success, title: "테스트", message: "테스트 메시지 입니다")
                }
            if smartBatteryViewModel.isCharging {
                Text("충전중")
                .customText(fontSize: FontSizeType.small.size, isBold: false)
            } else {
                Text("충전아님")
                .customText(fontSize: FontSizeType.small.size, isBold: false)
            }
            
        }
        .navigationTitle(CategoryType.smartBattery.title)
        .padding()
        .toastView(toast: $toast)
    }
}

#Preview {
    SmartBatteryView(smartBatteryViewModel: SmartBatteryViewModel(appSmartBatteryService: AppSmartBatteryService()))
}

