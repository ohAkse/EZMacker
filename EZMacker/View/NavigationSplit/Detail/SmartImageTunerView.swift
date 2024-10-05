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
    
    init(factory: ViewModelFactory) {
        _smartImageTunerViewModel = StateObject(wrappedValue: factory.createSmartImageTunerViewModel())
    }
    var body: some View {
        HStack(spacing: 15) {
            imageSectionView
            toolbarSectionView
                .frame(width: 50)
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
            Button("값 업데이트") {
                smartImageTunerViewModel.setInt64()
            }
            Button(action: saveImage) {
                Image(systemName: "square.and.arrow.down")
                    .font(.system(size: 20))
            }
            .disabled(smartImageTunerViewModel.image == nil)
            Button(action: toggleDrawing) {
                Image(systemName: isDrawing ? "pencil.slash" : "pencil")
                    .font(.system(size: 20))
            }
            .disabled(smartImageTunerViewModel.image == nil)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ezBackgroundColorStyle()
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
                    Text("이미지를 등록하세요")
                        .foregroundColor(.gray)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .ezBackgroundColorStyle()
            .onDrop(of: [UTType.image], isTargeted: nil) { providers in
                loadDroppedImage(from: providers)
                return true
            }
            .onChange(of: geometry.size) { _, newSize in
                smartImageTunerViewModel.updateFrameSize(newSize)
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
    private func saveImage() {
        smartImageTunerViewModel.saveImage(with: currentDrawing)
    }
    
    private func toggleDrawing() {
        isDrawing.toggle()
    }
}
