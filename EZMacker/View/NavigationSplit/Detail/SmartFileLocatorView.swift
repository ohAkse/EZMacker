//
//  SmartFileLocatorView.swift
//  EZMacker
//
//  Created by 박유경 on 7/5/24.
//

import SwiftUI
import EZMackerUtilLib

struct SmartFileLocatorView: View {
    @StateObject var smartFileLocatorViewModel: SmartFileLocatorViewModel
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    @State private var showingAlert = false
    @State private var showingErrorAlert = false
    @State private var newTabName = ""
    @State private var errorMessage = ""
    
    init(factory: ViewModelFactory) {
        _smartFileLocatorViewModel = StateObject(wrappedValue: factory.createSmartFileLocatorViewModel())
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    tabBar()
                    if let selectedTab = smartFileLocatorViewModel.savedData.selectedTab {
                        fileGridContent(for: selectedTab)
                    }
                }
            }
            .scrollIndicators(.automatic)
            .ezBackgroundColorStyle()
            
            if let selectedTab = smartFileLocatorViewModel.savedData.selectedTab {
                VStack {
                    Spacer()
                    HStack {
                        addFileButton(for: selectedTab)
                        Spacer()
                    }
                    .padding([.bottom, .leading], 10)
                }
            } else {
                Spacer()
                emptyStateView
            }
        }
        .alert("새 탭", isPresented: $showingAlert, actions: {
            newTabAlert
        }, message: {
            Text("탭 이름을 입력해 주세세요")
        })
        .alert("에러", isPresented: $showingErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .cornerRadius(12)
        .padding(30)
        .environmentObject(colorSchemeViewModel)
    }
    
    private func fileGridContent(for selectedTab: String) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 10)], spacing: 10) {
            ForEach(Array(smartFileLocatorViewModel.savedData.fileViewsPerTab[selectedTab, default: [:]].keys), id: \.self) { id in
                FileView(id: id,
                         fileInfo: smartFileLocatorViewModel.savedData.fileViewsPerTab[selectedTab]?[id] ?? .empty,
                         onDelete: { smartFileLocatorViewModel.deleteFileView(id: id, from: selectedTab) },
                         onDrop: { url in smartFileLocatorViewModel.setFileInfo(fileURL: url, for: id, in: selectedTab) })
                .id(id)
                .ezBackgroundColorStyle()
                
            }
        }
        .padding(10)
    }
    
    private func tabBar() -> some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 10) {
                if smartFileLocatorViewModel.savedData.tabs.isEmpty {
                    Spacer().frame(height: 50)
                } else {
                    ForEach(smartFileLocatorViewModel.savedData.tabs, id: \.self) { tab in
                        tabButton(for: tab)
                    }
                    .frame(height: 50)
                    
                }
                addTabButton
            }
            .contentShape(Rectangle())
        }
        .frame(height: 60)
        .ezTabbarBackgroundStyle()
    }
    private func tabButton(for tab: String) -> some View {
        Button(action: {
            smartFileLocatorViewModel.savedData.selectedTab = tab
        }, label: {
            HStack(alignment: .center, spacing: 5) {
                Text(tab)
                    .lineLimit(1)
                    .ezNormalTextStyle(fontSize: FontSizeType.small.size, isBold: false)
                    .frame(maxWidth: .infinity, alignment: .leading)
                deleteTabButton(for: tab)
                    .padding(.trailing, 5)
            }
            .padding(10)
            .frame(height: 30)
        })
        .ezTabbarButtonStyle()
        .frame(minWidth: 50, maxWidth: 130)
        .padding(.leading, 10)
    }
    
    private func deleteTabButton(for tab: String) -> some View {
        Button(
            action: {
                smartFileLocatorViewModel.deleteTab(tab)
            },
            label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.red)
            }
        )
        .buttonStyle(PlainButtonStyle())
    }
    
    private var addTabButton: some View {
        Button(action: { showingAlert = true },
               label: {})
        .ezButtonImageStyle(
            imageName: "plus.circle.fill",
            imageSize: CGSize(width: 30, height: 30),
            lightModeForegroundColor: ThemeColorType.orange.color,
            darkModeForegroundColor: ThemeColorType.orange.color,
            lightModeBackgroundColor: .clear,
            darkModeBackgroundColor: .clear,
            frameSize: CGSize(width: 30, height: 30)
        )
    }
    
    private func fileGridView(for selectedTab: String) -> some View {
        GeometryReader { _ in
            ZStack(alignment: .bottomTrailing) {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 10)]) {
                        ForEach(Array(smartFileLocatorViewModel.savedData.fileViewsPerTab[selectedTab, default: [:]].keys), id: \.self) { id in
                            FileView(id: id,
                                     fileInfo: smartFileLocatorViewModel.savedData.fileViewsPerTab[selectedTab]?[id] ?? .empty,
                                     onDelete: { smartFileLocatorViewModel.deleteFileView(id: id, from: selectedTab) },
                                     onDrop: { url in smartFileLocatorViewModel.setFileInfo(fileURL: url, for: id, in: selectedTab) })
                            .id(id)
                        }
                    }
                }
                .padding(10)
                addFileButton(for: selectedTab)
            }
        }
    }
    
    private func addFileButton(for selectedTab: String) -> some View {
        Button(action: { smartFileLocatorViewModel.addFileView(for: selectedTab) }, label: {})
            .ezButtonImageStyle(
                imageName: "plus.circle.fill",
                imageSize: CGSize(width: 30, height: 30),
                lightModeForegroundColor: ThemeColorType.cyan.color,
                darkModeForegroundColor: ThemeColorType.cyan.color,
                lightModeBackgroundColor: .clear,
                darkModeBackgroundColor: .clear,
                frameSize: CGSize(width: 30, height: 30)
            )
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Text("우측 상단의 +버튼을 눌러 탭을 추가 후 하단 +추가 해보세요. 화면에 파일을 드래그 후 클릭하면 해당 경로의 파일이 자동으로 열립니다.")
                .foregroundColor(.gray)
                .ezNormalTextStyle(fontSize: FontSizeType.small.size, isBold: false)
                .multilineTextAlignment(.center)
                .padding()
            
            Text("*주의: 파일명을 변경하거나 위치를 옮길 경우 바로가기 파일이 삭제됩니다.")
                .foregroundColor(.red)
                .ezNormalTextStyle(fontSize: FontSizeType.small.size, isBold: true)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
    }
    
    private var newTabAlert: some View {
        Group {
            TextField("탭 이름", text: $newTabName)
            Button("추가") {
                if !newTabName.isEmpty {
                    smartFileLocatorViewModel.addTab(newTabName)
                    newTabName = ""
                }
            }
            Button("취소", role: .cancel) { }
        }
    }
}

struct FileView: View {
    let id: UUID
    let fileInfo: FileQueryData
    let onDelete: () -> Void
    let onDrop: (URL) -> Void
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    @State private var isTargeted: Bool = false
    
    var body: some View {
        VStack {
            deleteButton.padding([.top, .trailing], 3)
            filePreview
            fileDetails
        }
        .frame(width: 150, height: 180)
        .padding(2)
        .ezTabbarGridStyle()
        .onDrop(of: [.fileURL], isTargeted: $isTargeted, perform: onDropFile)
        .onTapGesture(perform: openFile)
        .navigationTitle(CategoryType.smartFileLocator.title)
    }
    
    private var deleteButton: some View {
        HStack {
            Spacer()
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var filePreview: some View {
        Group {
            if let previewImage = fileInfo.thumbNail {
                Image(nsImage: previewImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: "doc.text")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(width: 100, height: 65)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private var fileDetails: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(fileInfo.fileName.isEmpty ? "등록 안됨" : fileInfo.fileName)
                .font(.headline)
                .lineLimit(1)
                .padding(.top, 3)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("타입: \(fileInfo.fileType.isEmpty ? "None" : fileInfo.fileType)")
                .padding([.top, .leading], 3)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("크기: \(fileInfo.fileSize) bytes")
                .padding([.top, .leading], 3)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("날짜: \(fileInfo.modificationDate?.getFormattedDate() ?? "Not Updated")")
                .padding([.top, .leading], 3)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func onDropFile(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }
        provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, _) in
            DispatchQueue.main.async {
                if let data = urlData as? Data,
                   let url = URL(dataRepresentation: data, relativeTo: nil) {
                    onDrop(url)
                }
            }
        }
        return true
    }
    
    private func openFile() {
        if let fileURL = fileInfo.fileURL {
            Logger.writeLog(.info, message: fileURL.path)
            NSWorkspace.shared.open(fileURL)
        }
    }
}
