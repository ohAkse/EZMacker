//
//  SmartImageTunerView.swift
//  EZMacker
//
//  Created by 박유경 on 9/28/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct SmartImageTunerView: View {
    @EnvironmentObject var systemThemeService: SystemThemeService
    @State private var toast: ToastData?
    @StateObject var smartImageTunerViewModel: SmartImageTunerViewModel
    @State private var isDrawing = false
    @State private var currentDrawing: [NSBezierPath] = []
    @State private var selectedTab: TunerTabType?
    @State private var imageSectionSize: CGSize = .zero
    init(factory: ViewModelFactory) {
        _smartImageTunerViewModel = StateObject(wrappedValue: factory.createSmartImageTunerViewModel())
    }
    
    var body: some View {
        HStack(spacing: 15) {
            imageSectionView
            toolbarSectionView
                .frame(width: 65)
        }
        .onAppear {
            smartImageTunerViewModel.bindNativeOutput()
        }
        .navigationTitle(CategoryType.smartImageTuner.title)
        .padding(30)
    }
    
    private var toolbarSectionView: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(TunerTabType.allCases, id: \.self) { tab in
                        EZImageTunerTabButtonView(
                            tab: tab,
                            isSelected: selectedTab == tab,
                            isDisabled: shouldDisableButton(for: tab),
                            action: { selectTab(tab) }
                        )
                    }
                }
                .padding(.vertical, 10)
            }
            .frame(width: 65, height: geometry.size.height)
        }
        .ezBackgroundColorStyle()
    }
    
    private func shouldDisableButton(for tab: TunerTabType) -> Bool {
        return smartImageTunerViewModel.image == nil
        // return ![.draw].contains(tab)
    }
    
    private func selectTab(_ tab: TunerTabType) {
        selectedTab = tab
        performAction(for: tab)
    }
    
    private func performAction(for tab: TunerTabType) {
        switch tab {
        case .rotate: smartImageTunerViewModel.setInt64() // 테스트용
        case .save: saveImage()
        case .draw: toggleDrawing()
        case .crop: cropImage()
        case .filter: filterImage()
        case .reset: resetImage()
        case .addText: addTextToImage()
        case .highlight: toggleHighlight()
        case .erase: toggleEraser()
        case .flip: flipImage()
        case .redo: redoImage()
        case .undo: undoImage()
        }
    }
    
    private var imageSectionView: some View {
        GeometryReader { geometry in
            ZStack {
                if let image = smartImageTunerViewModel.image {
                    Group {
                        switch smartImageTunerViewModel.displayMode {
                        case .keepAspectRatio:
                                Image(nsImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                        case .fillFrame:
                                Image(nsImage: image)
                                    .resizable()
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                        }
                    }
                    if isDrawing {
                        CanvasRepresentableView(currentDrawing: $currentDrawing, smartImageTunerViewModel: smartImageTunerViewModel)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                } else {
                    VStack {
                        Text("편집하고자 하는 이미지를 화면에 드래그하여 올려주세요.")
                            .foregroundColor(.gray)
                            .ezNormalTextStyle(fontSize: FontSizeType.small.size, isBold: false)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Text("*정보: 이미지를 올려놓으면 버튼이 활성화되며, 스크롤하여 더 많은 기능을 이용하실 수 있습니다.")
                            .foregroundColor(.red)
                            .ezNormalTextStyle(fontSize: FontSizeType.small.size, isBold: true)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .ezBackgroundColorStyle()
            .onDrop(of: [UTType.image], isTargeted: nil) { providers in
                loadDroppedImage(from: providers)
                return true
            }
            .contextMenu {
                if smartImageTunerViewModel.image != nil {
                    Button(
                        action: {
                            smartImageTunerViewModel.setDisplayMode(.keepAspectRatio)
                        },
                        label: {
                            HStack {
                                Text("비율 유지하기")
                                if smartImageTunerViewModel.displayMode == .keepAspectRatio {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    )
                    
                    Button(
                        action: {
                            smartImageTunerViewModel.setDisplayMode(.fillFrame)
                        },
                        label: {
                            HStack {
                                Text("이미지 리사이즈")
                                if smartImageTunerViewModel.displayMode == .fillFrame {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    )
                }
            }
            .preference(key: SizePreferenceKey.self, value: geometry.size)
            .onPreferenceChange(SizePreferenceKey.self) { newSize in
                imageSectionSize = newSize
            }
        }
    }
    private func loadDroppedImage(from providers: [NSItemProvider]) {
        if let item = providers.first {
            item.loadObject(ofClass: NSImage.self) { image, _ in
                if let image = image as? NSImage {
                    DispatchQueue.main.async {
                        smartImageTunerViewModel.setImage(image)
                    }
                }
            }
        }
    }
}

// MARK: 탭 버튼 선택에 따른 함수
extension SmartImageTunerView {
    private func saveImage() {
        smartImageTunerViewModel.saveImage(currentDrawing: currentDrawing, viewSize: imageSectionSize)
    }
    private func toggleDrawing() {
        isDrawing.toggle()
    }
    private func cropImage() {
        
    }
    private func filterImage() {
        
    }
    private func resetImage() {
        
    }
    private func addTextToImage() {
        
    }
    private func toggleHighlight() {
        
    }
    private func toggleEraser() {
        
    }
    private func flipImage() {
        
    }
    private func redoImage() {
        
    }
    private func undoImage() {
        
    }
}
