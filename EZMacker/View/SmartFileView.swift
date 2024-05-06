//
//  SmartFileView.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import SwiftUI
struct SmartFileView: View {
    @ObservedObject var smartFileViewModel: SmartFileViewModel
    @State private var toast: Toast?

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .customImage(imageScale: .large)
            Text(CategoryType.smartFile.title)
                .customText(fontSize: FontSizeType.small.size, isBold: false)
        }
        .navigationTitle(CategoryType.smartFile.title)
        .padding()
    }
}

#Preview {
    SmartFileView(smartFileViewModel: SmartFileViewModel(appSmartFileService: AppSmartFileService()))
    
}
