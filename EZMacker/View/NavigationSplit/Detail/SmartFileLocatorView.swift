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
    @State private var errorMessage = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(smartFileLocatorViewModel.tabs, id: \.self) { tab in
                                Button(action: {
                                    smartFileLocatorViewModel.selectedTab = tab
                                }) {
                                    HStack {
                                        Text(tab)
                                        Spacer()
                                        Button(action: {
                                            smartFileLocatorViewModel.deleteTab(tab)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                                .font(.system(size: 12))
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(smartFileLocatorViewModel.selectedTab == tab ? Color.blue.opacity(0.2) : Color.clear)
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
                
                if let selectedTab = smartFileLocatorViewModel.selectedTab {
                    ZStack(alignment: .bottomTrailing) {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                                ForEach(Array(smartFileLocatorViewModel.fileViewsPerTab[selectedTab, default: [:]].keys), id: \.self) { id in
                                    FileView(id: id, fileInfo: smartFileLocatorViewModel.fileViewsPerTab[selectedTab]?[id] ?? .empty, onDelete: {
                                        smartFileLocatorViewModel.deleteFileView(id: id, from: selectedTab)
                                    }, onDrop: { url in
                                        smartFileLocatorViewModel.setFileInfo(fileURL: url, for: id, in: selectedTab)
                                    })
                                }
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        Button(action: {
                            smartFileLocatorViewModel.addFileView(for: selectedTab)
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
            Button("추가") {
                if !newTabName.isEmpty {
                    smartFileLocatorViewModel.addTab(newTabName)
                    newTabName = ""
                }
            }
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
}

struct FileView: View {
    let id: UUID
    let fileInfo: FileInfo
    let onDelete: () -> Void
    let onDrop: (URL) -> Void
    @State private var isTargeted: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            if let previewImage = fileInfo.thumbNail {
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
            
            Text("파일 이름: \(fileInfo.fileName)")
                .lineLimit(1)
            Text("크기: \(fileInfo.fileSize) bytes")
            Text("타입: \(fileInfo.fileType)")
                .lineLimit(1)
        }
        .padding()
        .background(isTargeted ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2))
        .cornerRadius(10)
        .onDrop(of: [.fileURL], isTargeted: $isTargeted) { providers -> Bool in
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
        .onTapGesture {
            if let fileURL = fileInfo.fileURL {
                Logger.writeLog(.info, message: fileURL.path())
                NSWorkspace.shared.open(fileURL)
            }
        }
    }
}
