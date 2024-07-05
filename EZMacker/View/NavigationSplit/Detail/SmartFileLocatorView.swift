//
//  SmartFileLocatorView.swift
//  EZMacker
//
//  Created by 박유경 on 7/5/24.
//

import SwiftUI

struct SmartFileLocatorView: View {
    @StateObject var smartFileLocatorViewModel: SmartFileLocatorViewModel
    @State private var showingAlert = false
    @State private var showingErrorAlert = false
    @State private var newTabName = ""
    @State private var tabs: [String] = []
    @State private var selectedTab: String?
    @State private var fileViewsPerTab: [String: [UUID: FileView]] = [:]
    @State private var errorMessage = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(tabs, id: \.self) { tab in
                                Button(action: {
                                    selectedTab = tab
                                }) {
                                    Text(tab)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(selectedTab == tab ? Color.blue.opacity(0.2) : Color.clear)
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.blue, lineWidth: 1)
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingAlert = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
                .frame(height: geometry.size.height * 0.08)
                .background(Color.white)
                
                if let selectedTab = selectedTab {
                    ZStack(alignment: .bottomTrailing) {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                                ForEach(Array(fileViewsPerTab[selectedTab, default: [:]].values), id: \.id) { fileView in
                                    fileView
                                }
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        Button(action: {
                            addFileView(for: selectedTab)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.yellow)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding([.bottom, .trailing], 20)
                    }
                } else {
                    VStack {
                        Spacer()
                        Text("우측 상단의 +버튼을 눌러 탭을 추가 후 하단 +추가 해보세요. 화면에 파일을 드래그 후 클릭하면 해당 경로의 파일이 자동으로 열립니다.")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
            }
        }
        .background(Color.white)
        .alert("새 탭", isPresented: $showingAlert) {
            TextField("탭 이름", text: $newTabName)
            Button("추가", action: addTab)
            Button("취소", role: .cancel) { }
        } message: {
            Text("탭 이름을 입력해 주세세요")
        }
        .alert("에러", isPresented: $showingErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func addTab() {
        if !newTabName.isEmpty {
            if tabs.contains(newTabName) {
                errorMessage = "중복된 탭 이름입니다. 다른 이름으로 지정해주세요."
                showingErrorAlert = true
            } else {
                tabs.append(newTabName)
                selectedTab = newTabName
                fileViewsPerTab[newTabName] = [:]
                newTabName = ""
            }
        }
    }
    
    private func addFileView(for tab: String) {
        let newID = UUID()
        let newFileView = FileView(id: newID, smartFileLocatorViewModel: SmartFileLocatorViewModel(appSmartFileService: AppSmartFileService(), systemPreferenceService: SystemPreferenceService()))
        fileViewsPerTab[tab, default: [:]][newID] = newFileView
    }
}

struct FileView: View {
    let id: UUID
    @ObservedObject var smartFileLocatorViewModel: SmartFileLocatorViewModel
    @State private var isTargeted: Bool = false
    
    var body: some View {
        VStack {
            if let previewImage = smartFileLocatorViewModel.fileInfo.thumbNail {
                Image(nsImage: previewImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            } else {
                Image(systemName: "doc.text")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            }
            
            Text("파일 이름: \(smartFileLocatorViewModel.fileInfo.fileName)")
                .lineLimit(1)
            Text("크기: \(smartFileLocatorViewModel.fileInfo.fileSize) bytes")
            Text("타입: \(smartFileLocatorViewModel.fileInfo.fileType)")
                .lineLimit(1)
        }
        .padding()
        .background(isTargeted ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2))
        .cornerRadius(10)
        .onDrop(of: [.fileURL], isTargeted: $isTargeted, perform: dropFile)
        .onTapGesture(perform: openFile)
    }
    
    private func dropFile(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }
        provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
            DispatchQueue.main.async {
                if let data = urlData as? Data,
                   let url = URL(dataRepresentation: data, relativeTo: nil) {
                    smartFileLocatorViewModel.setFileInfo(fileURL: url)
                }
            }
        }
        return true
    }
    
    private func openFile() {
        if let fileURL = smartFileLocatorViewModel.fileInfo.fileURL {
            NSWorkspace.shared.open(fileURL)
        }
    }
}


