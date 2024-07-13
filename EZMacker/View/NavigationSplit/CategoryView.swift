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
                categoryRow(for: .smartWifi)                
            }
            .customNormalTextFont(fontSize: FontSizeType.small.size, isBold: false)
            .frame(minHeight: 40)

            Section(CategorySectionType.categoryUtilitySection.title) {
                categoryRow(for: .smartFileLocator)
                categoryRow(for: .smartFileSearch)
            }
            .customNormalTextFont(fontSize: FontSizeType.small.size, isBold: false)
            .frame(minHeight: 40)
            
            Section(CategorySectionType.settingSection.title) {
                categoryRow(for: .smartNotificationAlarm)
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

        }
        .padding(.leading, 5)
        .frame(minHeight: 20)
        .tag(category)
    }
}
