//
//  SmartFileSearchView.swift
//  EZMacker
//
//  Created by 박유경 on 7/5/24.
//

import SwiftUI

struct SmartFileSearchView: View {
    @StateObject var smartFileSearchViewModel: SmartFileSearchViewModel
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            searchInputView
            fileListView
        }
        .navigationTitle(CategoryType.smartFileSearch.title)
        .padding(30)
        
    }
    
    // 검색 입력 뷰
    private var searchInputView: some View {
        HStack {
            TextField("찾고자 하는 파일 이름을 검색하여 주세요.", text: $smartFileSearchViewModel.searchText)
                .padding(.leading, 10)
                .frame(height: 45)
                .ezTextFieldStyle()
            Button("검색") {
                smartFileSearchViewModel.search()
            }
            .frame(width: 55, height: 45)
            .ezButtonStyle()
        }
    }
    
    // 파일 정보 리스트 뷰
    private var fileListView: some View {
        List(smartFileSearchViewModel.searchResults, id: \.id) { fileInfo in
            VStack(alignment: .leading) {
                Text(fileInfo.fileName)
                    .font(.headline)
                if let fileURL = fileInfo.fileURL {
                    Text(fileURL.path)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text(fileInfo.fileType)
                    Text(ByteCountFormatter.string(fromByteCount: fileInfo.fileSize, countStyle: .file))
                    if let modDate = fileInfo.modificationDate {
                        Text(modDate, style: .date)
                    }
                }
                
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding(5)
            .ezListRowStyle()
            .contextMenu {
                if let fileURL = fileInfo.fileURL {
                    Button("Finder에서 열기") {
                        smartFileSearchViewModel.openInFinder(fileURL)
                    }
                }
            }
        }
        .ezListViewStyle()
    }
}
