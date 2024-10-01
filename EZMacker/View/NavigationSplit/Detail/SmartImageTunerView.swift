//
//  SmartImageTunerView.swift
//  EZMacker
//
//  Created by 박유경 on 9/28/24.
//

import SwiftUI

struct SmartImageTunerView: View {
    @EnvironmentObject var systemThemeService: SystemThemeService
    @State private var toast: ToastData?
    @StateObject var smartImageTunerViewModel: SmartImageTunerViewModel
    
    init(factory: ViewModelFactory) {
        _smartImageTunerViewModel = StateObject(wrappedValue: factory.createSmartImageTunerViewModel())
    }
    
    var body: some View {
        ViewThatFits {
            HStack(spacing: 15) {
                imageSectionView
                toolbarSectionView
                .frame(width: 50)
            }
        }
        .onAppear {
            smartImageTunerViewModel.bindNativeOutput()
        }
        .navigationTitle(CategoryType.smartImageTuner.title)
        .padding(30)
    }
    
    private var toolbarSectionView: some View {
        VStack {
            Text("툴바 영역")
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ezBackgroundColorStyle()
    }
    
    private var imageSectionView: some View {
        VStack {
            Text("이미지 영역")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ezBackgroundColorStyle()
    }
}
