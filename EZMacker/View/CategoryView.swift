//
//  CategoryView.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import SwiftUI
struct CategoryView: View {
    @Binding var selectionValue: CategoryType
    var body: some View {
        List(selection: $selectionValue) {
            Section(CategorySectionType.categoryMainSection.title) {
                categoryRow(for: .smartBattery)
                categoryRow(for: .smartFile)
            }
        }
    }
    private func categoryRow(for category: CategoryType) -> some View {
         return HStack {
             Image(systemName: category.imageName)
                 .customImage(imageScale: .large)
             Text(category.title)
                 .customText(fontSize: FontSizeType.small.size, isBold: false)
         }
         .padding(.leading, 5)
         .tag(category)
     }
}


