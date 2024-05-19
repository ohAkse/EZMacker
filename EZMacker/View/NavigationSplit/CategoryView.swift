//
//  CategoryView.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import SwiftUI

struct CategoryView: View {
    @Binding var selectionValue: CategoryType
    @State private var showAlert = false
    var body: some View {
        List(selection: $selectionValue) {
            Section(CategorySectionType.categoryMainSection.title) {
                categoryRow(for: .smartBattery)
                
                categoryRow(for: .smartFile)
                
            }
            .customNormalTextFont(fontSize: FontSizeType.small.size, isBold: false)

            .frame(minHeight: 40)
            
            Section(CategorySectionType.settingSection.title) {
                categoryRow(for: .notificationAlarm)
            }
            .customNormalTextFont(fontSize: FontSizeType.small.size, isBold: false)
            .frame(minHeight: 40)
        }
    }
    
    private func categoryRow(for category: CategoryType) -> some View {
        return HStack {
            Image(systemName: category.imageName)
                .customNormalImage(imageScale: .large, width:20, height: 20)
            Text(category.title)
                .customNormalTextFont(fontSize: FontSizeType.small.size, isBold: false)
                .onTapGesture {
                    if category == .smartFile || category == .notificationAlarm{
                        showAlert = true
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("정보"), message: Text("준비중입니다."), dismissButton: .default(Text("OK")))
                }
        }
        .padding(.leading, 5)
        .frame(minHeight: 20)
        .tag(category)
    }
}
