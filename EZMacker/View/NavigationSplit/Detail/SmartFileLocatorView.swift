//
//  SmartFileLocatorView.swift
//  EZMacker
//
//  Created by 박유경 on 7/5/24.
//

import SwiftUI

struct SmartFileLocatorView: View {
    @ObservedObject var smartFileLocatorViewModel: SmartFileLocatorViewModel
    @State private var showingAlert = false
    @State private var showingErrorAlert = false
    @State private var newTabName = ""
    @State private var errorMessage = ""
    
var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                tabBar(height: geometry.size.height * 0.08)
                
                if let selectedTab = smartFileLocatorViewModel.savedData.selectedTab {
                    fileGridView(for: selectedTab)
                } else {
                    emptyStateView
                }
            }
        }
        .background(Color.white)
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
    }
    
    private func tabBar(height: CGFloat) -> some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    ForEach(smartFileLocatorViewModel.savedData.tabs, id: \.self) { tab in
                        tabButton(for: tab)
                    }
                }
            }
        
            Spacer()
            addTabButton
        }
        .padding(.horizontal)
        .frame(height: height)
        .background(Color.white)
    }
    
    private func tabButton(for tab: String) -> some View {
        Button(action: { smartFileLocatorViewModel.savedData.selectedTab = tab }) {
            HStack {
                Text(tab)
                Spacer()
                deleteTabButton(for: tab)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(smartFileLocatorViewModel.savedData.selectedTab == tab ? Color.blue.opacity(0.2) : Color.clear)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func deleteTabButton(for tab: String) -> some View {
        Button(action: { smartFileLocatorViewModel.deleteTab(tab) }) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
                .font(.system(size: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var addTabButton: some View {
        Button(action: { showingAlert = true }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func fileGridView(for selectedTab: String) -> some View {
        ZStack(alignment: .bottomTrailing) {
            if smartFileLocatorViewModel.savedData.fileViewsPerTab[selectedTab, default: [:]].isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                        ForEach(Array(smartFileLocatorViewModel.savedData.fileViewsPerTab[selectedTab, default: [:]].keys), id: \.self) { id in
                            FileView(id: id,
                                     fileInfo: smartFileLocatorViewModel.savedData.fileViewsPerTab[selectedTab]?[id] ?? .empty,
                                     onDelete: { smartFileLocatorViewModel.deleteFileView(id: id, from: selectedTab) },
                                     onDrop: { url in smartFileLocatorViewModel.setFileInfo(fileURL: url, for: id, in: selectedTab) })
                        }
                    }
                    .padding()
                }
            }
            
            addFileButton(for: selectedTab)
        }
    }
    
    private func addFileButton(for selectedTab: String) -> some View {
        Button(action: { smartFileLocatorViewModel.addFileView(for: selectedTab) }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.yellow)
        }
        .buttonStyle(PlainButtonStyle())
        .padding([.bottom, .trailing], 20)
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Text("우측 상단의 +버튼을 눌러 탭을 추가 후 하단 +추가 해보세요. 화면에 파일을 드래그 후 클릭하면 해당 경로의 파일이 자동으로 열립니다.")
                .foregroundColor(.gray)
                .customNormalTextFont(fontSize: FontSizeType.small.size, isBold: false)
                .multilineTextAlignment(.center)
                .padding()
            
            Text("*주의: 파일명을 변경하거나 위치를 옮길 경우 바로가기 파일이 삭제됩니다.")
                .foregroundColor(.red)
                .customNormalTextFont(fontSize: FontSizeType.small.size, isBold: true)
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
    let fileInfo: FileInfo
    let onDelete: () -> Void
    let onDrop: (URL) -> Void
    @State private var isTargeted: Bool = false
    
    var body: some View {
        VStack {
            deleteButton
            filePreview
            fileDetails
            Spacer()
        }
        .padding()
        .background(isTargeted ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2))
        .cornerRadius(10)
        .onDrop(of: [.fileURL], isTargeted: $isTargeted, perform: handleDrop)
        .onTapGesture(perform: openFile)
    }
    
    private var deleteButton: some View {
        HStack {
            Spacer()
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .imageScale(.large)
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
        .frame(width: 100, height: 70)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private var fileDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(fileInfo.fileName.hasSuffix(".app") ? String(fileInfo.fileName.dropLast(4)) : fileInfo.fileName)
                .font(.headline)
                .lineLimit(1)
                .padding(.top, 4)
            
            Text("타입: \(fileInfo.fileType)")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
            Text("크기: \(fileInfo.fileSize) bytes")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("날짜: \(fileInfo.modificationDate?.getFormattedDate() ?? "Not available")")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .padding(.top, 8)
    }
    
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }
        provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
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
