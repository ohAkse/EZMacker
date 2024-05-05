//
//  CategoryView.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import SwiftUI
struct CategoryView: View {
    @Binding var selectionValue: CategoryType
    @Environment(\.colorScheme) var colorScheme
    private var textColor: Color {
        return colorScheme == .light ? ThemeColor.lightBlack.color : ThemeColor.lightWhite.color
    }
    private var imageForegroundColor: Color {
        return colorScheme == .light ? ThemeColor.lightGreen.color : ThemeColor.lightBlue.color
    }
    
    
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
                 .foregroundColor(imageForegroundColor)
             Text(category.title)
                 .customText(textColor: textColor, fontSize: FontSizeType.small.size)
         }
         .padding(.leading, 5)
         .tag(category)
     }
}


