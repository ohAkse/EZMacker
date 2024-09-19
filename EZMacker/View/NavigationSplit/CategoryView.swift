//
//  CategoryView.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import SwiftUI

struct CategoryView: View {
    @EnvironmentObject var appThemeManager: AppThemeManager
    @Binding var selectionValue: CategoryType
    @State private var showAlert = false
    var body: some View {
        List(selection: $selectionValue) {
            Section(CategorySectionType.categoryMainSection.title) {
                if (AppEnvironment.shared.macBookType == .macBookPro) || (AppEnvironment.shared.macBookType == .macBookAir) {
                    categoryRow(for: .smartBattery)
                }
                categoryRow(for: .smartWifi)
            }
            .ezNormalTextStyle(fontSize: FontSizeType.small.size, isBold: false)
            .frame(minHeight: 40)

            Section(CategorySectionType.categoryUtilitySection.title) {
                categoryRow(for: .smartFileLocator)
                categoryRow(for: .smartFileSearch)
            }
            .ezNormalTextStyle(fontSize: FontSizeType.small.size, isBold: false)
            .frame(minHeight: 40)
            
            Section(CategorySectionType.settingSection.title) {
                categoryRow(for: .smartNotificationAlarm)
            }
            .ezNormalTextStyle(fontSize: FontSizeType.small.size, isBold: false)
            .frame(minHeight: 40)
        }
    }
    
    private func categoryRow(for category: CategoryType) -> some View {
        return HStack {
            Image(systemName: category.imageName)
                .ezNormalImageStyle(imageScale: .large, width: 20, height: 20)
            Text(category.title)
                .ezNormalTextStyle(fontSize: FontSizeType.small.size, isBold: false)

        }
        .padding(.leading, 5)
        .frame(minHeight: 20)
        .tag(category)
    }
}
