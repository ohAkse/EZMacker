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
    @StateObject var smartImageTunerViewModel: SmartImageTunerViewModel
    @State private var toast: ToastData?
    @State private var isPopupPresented = false
    @State private var selectedTab: TunerTabType?
    /**드로잉 **/
    @State private var isDrawing = false
    @State private var currentDrawing: [NSBezierPath] = []
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
            .onAppear(perform: bindViewModel)
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
        Group {
            if isPopupPresented, let selectedTab = selectedTab {
                popupViewForTab(selectedTab)
                    .frame(width: 250)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
    }
    
    private var toolbarSection: some View {
        toolbarSectionView
            .frame(width: 65)
    }
    
    private func bindViewModel() {
        smartImageTunerViewModel.bindNativeOutput()
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
        .ezBackgroundColorStyle()
    }
    
    private var imageSectionView: some View {
        GeometryReader { geometry in
            ZStack {
                if let image = smartImageTunerViewModel.image {
                    imageView(for: image, in: geometry)
                    if isDrawing {
                        CanvasRepresentableView(currentDrawing: $currentDrawing, smartImageTunerViewModel: smartImageTunerViewModel)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                } else {
                    emptyStateView
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .ezBackgroundColorStyle()
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
            if smartImageTunerViewModel.image != nil {
                Button("비율 유지하기") {
                    smartImageTunerViewModel.setDisplayMode(.keepAspectRatio)
                }
                
                Button("이미지 리사이즈") {
                    smartImageTunerViewModel.setDisplayMode(.fillFrame)
                }
            }
        }
    }
}

// MARK: - Helper Methods
extension SmartImageTunerView {
    private func selectTab(_ tab: TunerTabType) {
        selectedTab = tab
        if selectedTab == .save {
            saveImage()
        } else {
            isPopupPresented = true
        }
    }
    
    private func shouldDisableButton(for tab: TunerTabType) -> Bool {
        return smartImageTunerViewModel.image == nil
    }
    
    private func loadDroppedImage(from providers: [NSItemProvider]) {
        guard let item = providers.first else { return }
        item.loadObject(ofClass: NSImage.self) { image, _ in
            if let image = image as? NSImage {
                DispatchQueue.main.async {
                    self.smartImageTunerViewModel.setImage(image)
                }
            }
        }
    }
    
    private func popupViewForTab(_ tab: TunerTabType) -> AnyView {
        switch tab {
        case .reset, .rotate, .draw:
            return AnyView(DrawToolPopupView(isPresented: $isPopupPresented, completion: DrawAction))
        case .filter:
            return AnyView(FilterPopupView(isPresented: $isPopupPresented, completion: FilterAction))
        case .addText, .undo:
            return AnyView(AddTextPopupView(isPresented: $isPopupPresented, completion: addTextAction))
        default:
            return AnyView(EmptyView())
        }
    }
}

// MARK: - 버튼 기능별 함수들
extension SmartImageTunerView {
    private func DrawAction(_ action: String) {
        print("Draw action: \(action)")
        isPopupPresented = false
        toggleDrawing()
    }
    
    private func FilterAction(_ filter: String) {
        print("Apply filter: \(filter)")
        isPopupPresented = false
    }
    
    private func addTextAction(_ text: String) {
        print("Add text: \(text)")
        isPopupPresented = false
    }
    
    private func toggleDrawing() {
        isDrawing.toggle()
    }
    
    private func saveImage() {
        smartImageTunerViewModel.saveImage(currentDrawing: currentDrawing, viewSize: imageSectionSize)
        toast = ToastData(type: .error, message: "ㅇㅇ")
    }
}
