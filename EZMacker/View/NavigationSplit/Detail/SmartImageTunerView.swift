//
//  SmartImageTunerView.swift
//  EZMacker
//
//  Created by 박유경 on 9/28/24.
//

import SwiftUI
import EZMackerUtilLib
import UniformTypeIdentifiers

struct SmartImageTunerView: View {
    @EnvironmentObject var systemThemeService: SystemThemeService
    @StateObject var smartImageTunerViewModel: SmartImageTunerViewModel
    @State private var toast: ToastData?
    @State private var isPopupPresented = false
    @State private var isPenToolActive = false
    @State private var selectedTab: TunerTabType?
    /**드로잉 **/
    @State private (set) var penToolSetting: PenToolSetting = .init()
    /**이미지 스케일링**/
    @State private var imageSectionSize: CGSize = .zero
    
    init(factory: ViewModelFactory) {
        _smartImageTunerViewModel = StateObject(wrappedValue: factory.createSmartImageTunerViewModel())
    }
    
    var body: some View {
        GeometryReader { _ in
            HStack(spacing: 15) {
                imageSectionRootView
                toolbarSection
            }
            .padding(30)
            .navigationTitle(CategoryType.smartImageTuner.title)
            .animation(.easeInOut(duration: 0.3), value: isPopupPresented)
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
        let spacing: CGFloat = 10
        
        let tabCenterY = CGFloat(tabIndex) * (tabHeight + spacing) + tabHeight / 2
        let popupHeight: CGFloat = 200
        
        let minY = popupHeight / 2
        let maxY = geometry.size.height - popupHeight / 2
        
        var y = tabCenterY
        
        if y - popupHeight / 2 < 0 {
            y = minY
        } else if y + popupHeight / 2 > geometry.size.height {
            y = maxY
        }
        
        return y
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
            ZStack {
                if let image = smartImageTunerViewModel.originImage {
                    imageView(for: image, in: geometry)
                    CanvasRepresentableView(penToolSetting: $penToolSetting)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .allowsHitTesting(isPenToolActive)
                } else {
                    emptyStateView
                }
            }
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
    
    private func imageView(for image: NSImage, in geometry: GeometryProxy) -> AnyView {
        switch smartImageTunerViewModel.displayMode {
        case .keepAspectRatio:
            return AnyView(
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
            )
        case .fillFrame:
            return AnyView(
                    Image(nsImage: image)
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

// MARK: - Helper Methods
extension SmartImageTunerView {
    private func selectTab(_ tab: TunerTabType) {
        guard !shouldDisableButton(for: tab) else { return }
        selectedTab = tab
        isPenToolActive = (tab == .pen)
        switch tab {
        case .pen, .filter, .addText:
            isPopupPresented = true
        case .save:
            saveImage()
            selectedTab = nil
        case .reset:
            resetImage()
            selectedTab = nil
        case .undo:
            undoImage()
            selectedTab = nil
        case .redo:
            redoImage()
            selectedTab = nil
        case .rotate:
            rotateImage()
            selectedTab = nil
        case .flip:
            flopImage()
            selectedTab = nil
        default:
            isPenToolActive = false
            isPopupPresented = true
        }
    }
    
    private func shouldDisableButton(for tab: TunerTabType) -> Bool {
        switch tab {
        case .reset:
            return smartImageTunerViewModel.originImage == nil || (!penToolSetting.canUndo && !penToolSetting.canRedo)
        case .undo:
            return smartImageTunerViewModel.originImage == nil || !penToolSetting.canUndo
        case .redo:
            return smartImageTunerViewModel.originImage == nil || !penToolSetting.canRedo
        default:
            return smartImageTunerViewModel.originImage == nil
        }
    }
    
    private func loadDroppedImage(from providers: [NSItemProvider]) {
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
            default:
                return AnyView(EmptyView())
            }
        }
}

// MARK: - 팝업이 나타나는 함수
extension SmartImageTunerView {
    private func onPenSettingChanged(_ settings: PenToolSetting) {
          penToolSetting = settings
          isPopupPresented = false
      }
      
    private func onEraserSettingChanged(_ setting: String) {
          isPopupPresented = false
      }
      
      private func onFilterChanged(_ filter: String) {
          isPopupPresented = false
      }
      
      private func onAddTextChanged(_ text: String) {
          isPopupPresented = false
      }
}

// MARK: - 팝업이 나타나지 않는 함수
extension SmartImageTunerView {
    private func saveImage() {
        smartImageTunerViewModel.saveImage(currentDrawing: penToolSetting, viewSize: imageSectionSize) { result in
            switch result {
            case .success:
                self.toast = ToastData(type: .success, message: "이미지가 성공적으로 저장되었습니다.")
            case .cancelled:
                break
            case .error(let errorMessage):
                self.toast = ToastData(type: .error, message: "이미지 저장에 실패했습니다: \(errorMessage)")
            }
        }
    }
    private func resetImage() {
        penToolSetting = .init()
    }
    private func undoImage() {
        penToolSetting.undo()
    }
    private func redoImage() {
        penToolSetting.redo()
    }
    private func rotateImage() {
        // TODO: 차후 UI선택버튼 추가
        smartImageTunerViewModel.rotateImage(rotateType: .ROTATE_90_COUNTERCLOCKWISE)
    }
    private func flopImage() {
        // TODO: 차후 UI선택버튼 추가
        smartImageTunerViewModel.flipImage(flipType: .Horizontal)
    }
}
