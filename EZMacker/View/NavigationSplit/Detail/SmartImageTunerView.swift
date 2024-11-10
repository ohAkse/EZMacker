//
//  SmartImageTunerView.swift
//  EZMacker
//
//  Created by 박유경 on 9/28/24.
//

import SwiftUI
import EZMackerUtilLib
import EZMackerImageLib
import UniformTypeIdentifiers

struct SmartImageTunerView: View {
    @EnvironmentObject var systemThemeService: SystemThemeService
    @StateObject var smartImageTunerViewModel: SmartImageTunerViewModel
    @State private var toast: ToastData?
    @State private var isPopupPresented = false
    @State private(set) var isPenToolActive = false
    @State private(set) var selectedTab: TunerTabType?
    @State private(set) var imageSectionSize: CGSize = .zero
    
    // 펜, 텍스트 UI요소
    @State private(set) var penToolSetting: PenToolSetting = .init()
    @State private(set) var textItemList: [TextItem] = []
    
    init(factory: ViewModelFactory) {
        _smartImageTunerViewModel = StateObject(wrappedValue: factory.createSmartImageTunerViewModel())
    }
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                HStack(spacing: 15) {
                    imageSectionRootView
                    toolbarSection
                }
                .padding(30)
                .navigationTitle(CategoryType.smartImageTuner.title)
                .animation(.easeInOut(duration: 0.3), value: isPopupPresented)
                
                if smartImageTunerViewModel.isProcessing {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                    EZLoadingView(size: 150, text: "이미지 처리 중...")
                }
            }
        }
    }
    
    private var imageSectionRootView: some View {
        ZStack(alignment: .trailing) {
            imageSectionView
            popupOverlay
        }
        .toastView(toast: $toast)
    }
    
    private var popupOverlay: some View {
        GeometryReader { geometry in
            Group {
                if isPopupPresented, let selectedTab = selectedTab {
                    popupViewForTab(selectedTab)
                        .frame(width: 250)
                        .position(x: geometry.size.width - 115,
                                  y: adjustYPosition(for: selectedTab, in: geometry))
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
        }
    }

    private func adjustYPosition(for tab: TunerTabType, in geometry: GeometryProxy) -> CGFloat {
        let tabIndex = TunerTabType.allCases.firstIndex(of: tab) ?? 0
        let tabHeight: CGFloat = 50
        let popupHeight: CGFloat = 200
        
        let tabCenterY = CGFloat(tabIndex) * (tabHeight + 10) + tabHeight / 2
        let y = tabCenterY
        
        switch y {
        case ..<(popupHeight / 2): return popupHeight / 2
        case (geometry.size.height - popupHeight / 2)...: return geometry.size.height - popupHeight / 2
        default: return y
        }
    }
    
    private var toolbarSection: some View {
        toolbarSectionView
            .frame(width: 65)
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
            .background(Color.clear)
        }
        .ezBackgroundStyle()
    }
    private var imageSectionView: some View {
        GeometryReader { geometry in
            mainContentArea(in: geometry)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .ezBackgroundStyle()
                .onDrop(of: [UTType.image], isTargeted: nil) { providers in
                    loadDroppedImage(from: providers)
                    return true
                }
                .contextMenu { imageContextMenu }
                .preference(key: SizePreferenceKey.self, value: geometry.size)
                .onPreferenceChange(SizePreferenceKey.self) { newSize in
                    imageSectionSize = newSize
                }
        }
    }

    // MARK: - ImageSection Components
    private func mainContentArea(in geometry: GeometryProxy) -> some View {
        ZStack {
            if let image = smartImageTunerViewModel.originImage {
                imageLayer(image, in: geometry)
                textOverlayLayer(in: geometry)
                drawingLayer(in: geometry)
            } else {
                emptyStateView
            }
        }
    }

    private func imageLayer(_ image: NSImage, in geometry: GeometryProxy) -> some View {
        imageView(for: image, in: geometry)
    }

    private func textOverlayLayer(in geometry: GeometryProxy) -> some View {
        ForEach(textItemList) { overlay in
            if let index = textItemList.firstIndex(where: { $0.id == overlay.id }) {
                EZTextEditorView(
                    textItem: $textItemList[index],
                    onUpdate: { updatedOverlay in
                        updateTextOverlay(updatedOverlay, for: overlay)
                    },
                    onDelete: { deleteTextOverlay(overlay) },
                    onConfirm: { updatedOverlay in
                        updateTextOverlay(updatedOverlay, for: overlay)
                    }
                )
            }
        }
    }

    private func drawingLayer(in geometry: GeometryProxy) -> some View {
        CanvasRepresentableView(penToolSetting: $penToolSetting)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .allowsHitTesting(isPenToolActive)
    }
    
    private func imageView(for image: NSImage, in geometry: GeometryProxy) -> AnyView {
           let displayImage = smartImageTunerViewModel.currentImage ?? image
           
           switch smartImageTunerViewModel.displayMode {
           case .keepAspectRatio:
               return AnyView(
                   Image(nsImage: displayImage)
                       .resizable()
                       .aspectRatio(contentMode: .fit)
                       .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
               )
           case .fillFrame:
               return AnyView(
                   Image(nsImage: displayImage)
                       .resizable()
                       .frame(width: geometry.size.width, height: geometry.size.height)
               )
           }
       }
    
    private var emptyStateView: some View {
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
    
    private var imageContextMenu: some View {
        Group {
            if smartImageTunerViewModel.originImage != nil {
                Button("비율 유지") {
                    smartImageTunerViewModel.setDisplayMode(.keepAspectRatio)
                }
                Button("전체비율 유지") {
                    smartImageTunerViewModel.setDisplayMode(.fillFrame)
                }
            }
        }
    }
}

extension SmartImageTunerView {
    private func selectTab(_ tab: TunerTabType) {
        guard !shouldDisableButton(for: tab) else { return }
        selectedTab = tab
        
        isPenToolActive = (tab == .pen)
        for index in textItemList.indices {
            textItemList[index].isEditing = false
        }

        switch tab {
        case .pen, .filter, .addText:
            isPopupPresented = true
        case .save:
            saveImage()
        case .reset:
            resetImage()
        case .undo:
            undoImage()
        case .redo:
            redoImage()
        default:
            isPenToolActive = false
            isPopupPresented = true
        }
    }
    
    private func shouldDisableButton(for tab: TunerTabType) -> Bool {
        switch tab {
        case .reset:
            return smartImageTunerViewModel.originImage == nil || (!penToolSetting.canUndo && !penToolSetting.canRedo &&
                    textItemList.isEmpty && !smartImageTunerViewModel.hasChanges)
        case .undo:
            return smartImageTunerViewModel.originImage == nil || !penToolSetting.canUndo
        case .redo:
            return smartImageTunerViewModel.originImage == nil || !penToolSetting.canRedo
        default:
            return smartImageTunerViewModel.originImage == nil
        }
    }
    
    private func loadDroppedImage(from providers: [NSItemProvider]) {
        penToolSetting = .init()
        textItemList.removeAll()
        guard let item = providers.first else { return }
        item.loadObject(ofClass: NSImage.self) { image, _ in
            if let image = image as? NSImage {
                DispatchQueue.main.async {
                    self.smartImageTunerViewModel.setUploadImage(image)
                }
            }
        }
    }
    private func popupViewForTab(_ tab: TunerTabType) -> AnyView {
            switch tab {
            case .pen:
                return AnyView(EZPenPopupView(isPresented: $isPopupPresented, penToolSetting: $penToolSetting, completion: onPenSettingChanged))
            case .filter:
                return AnyView(EZFilterPopupView(isPresented: $isPopupPresented, completion: onFilterChanged))
            case .addText:
                return AnyView(EZAddTextPopupView(isPresented: $isPopupPresented, completion: onAddTextChanged))
            case .flip:
                return AnyView(EZFlipPopupView(isPresented: $isPopupPresented, completion: onFlipChanged))
            case .rotate:
                return AnyView(EZRotationPopupView(isPresented: $isPopupPresented, completion: onRotateChanged))
            default:
                return AnyView(EmptyView())
            }
        }
}

// MARK: - 팝업이 나타나는 함수
extension SmartImageTunerView {
    private func onPenSettingChanged(_ settings: PenToolSetting) {
        penToolSetting = settings
    }

    private func onFilterChanged(_ filtertype: FilterType) {
        smartImageTunerViewModel.filterImage(filterType: filtertype)
        isPopupPresented = false
        selectedTab = nil
    }

    private func onAddTextChanged(_ overlay: TextItem) {
         textItemList.append(overlay)
         isPopupPresented = false
         selectedTab = nil
     }
    private func updateTextOverlay(_ updatedOverlay: TextItem, for overlay: TextItem) {
        if let index = textItemList.firstIndex(where: { $0.id == overlay.id }) {
            textItemList[index] = updatedOverlay
        }
    }

    private func deleteTextOverlay(_ overlay: TextItem) {
        textItemList.removeAll { $0.id == overlay.id }
    }
    private func onRotateChanged(_ rotateType: RotateType) {
        smartImageTunerViewModel.rotateImage(rotateType: rotateType)
        isPopupPresented = false
        selectedTab = nil
    }
    private func onFlipChanged(_ flipType: FlipType) {
        smartImageTunerViewModel.flipImage(flipType: flipType)
        isPopupPresented = false
        selectedTab = nil
    }
}

// MARK: - 팝업이 나타나지 않는 함수
extension SmartImageTunerView {
    private func saveImage() {
        smartImageTunerViewModel.saveImage(currentDrawing: penToolSetting, textOverlays: textItemList, viewSize: imageSectionSize) { result in
            switch result {
            case .success:
                self.toast = ToastData(type: .success, message: "이미지가 성공적으로 저장되었습니다.")
            case .cancelled:
                break
            case .error(let errorMessage):
                self.toast = ToastData(type: .error, message: "이미지 저장에 실패했습니다: \(errorMessage)")
            }
            selectedTab = nil
        }
    }
    private func resetImage() {
        penToolSetting = .init()
        textItemList.removeAll()
        smartImageTunerViewModel.resetImage()
        selectedTab = nil
    }
    private func undoImage() {
        penToolSetting.undo()
        selectedTab = nil
    }
    private func redoImage() {
        penToolSetting.redo()
        selectedTab = nil
    }
}
