//
//  SmartFileSearchView.swift
//  EZMacker
//
//  Created by 박유경 on 7/5/24.
//

import SwiftUI

struct SmartFileSearchView: View {
    @ObservedObject var smartFileSearchViewModel: SmartFileSearchViewModel
    
    // 검색 입력 뷰
    private var searchInputView: some View {
        HStack {
            TextField("검색어 입력", text: $smartFileSearchViewModel.searchText)
                .padding(.leading, 10)
                .frame(height: 45)
                .textFieldStyle(PlainTextFieldStyle())
                .background(Color.white)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius:  12).stroke(Color.clear))
            Button("확인") {
                smartFileSearchViewModel.search()
            }
            .frame(width: 50, height: 45)
            .buttonStyle(PlainButtonStyle())
            .background(Color.blue)
            .customBackgroundColor()
        }
        .cornerRadius(12)
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
            .listRowBackground(Color.white)
            .contextMenu {
                if let fileURL = fileInfo.fileURL {
                    Button("Finder에서 열기") {
                        smartFileSearchViewModel.openInFinder(fileURL)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(PlainListStyle())
        .customBackgroundColor()
        .cornerRadius(12)
    }
    
    
    var body: some View {
        VStack(spacing: 16) {
            searchInputView
            fileListView
        }
        .navigationTitle(CategoryType.smartFileSearch.title)
        .padding(30)
        
    }
}
