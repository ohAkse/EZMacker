//
//  SmartFileView.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import SwiftUI
struct SmartFileView: View {
    @ObservedObject var smartFileViewModel: SmartFileViewModel
    @State private var toast: Toast?

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .customImage1(imageScale: .large, width:20, height: 20)
            Text(CategoryType.smartFile.title)
                .customFont1(fontSize: FontSizeType.small.size, isBold: false)
        }
        .navigationTitle(CategoryType.smartFile.title)
        .padding()
    }
}

#Preview {
    SmartFileView(smartFileViewModel: SmartFileViewModel(appSmartFileService: AppSmartFileService()))
    
}
