//
//  SmartFileSearchView.swift
//  EZMacker
//
//  Created by 박유경 on 7/5/24.
//

import SwiftUI

struct SmartFileSearchView: View {
    @ObservedObject var smartFileSearchViewModel: SmartFileSearchViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                TextField("검색어 입력", text: $smartFileSearchViewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("확인") {
                    smartFileSearchViewModel.search()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            
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
                .contextMenu {
                    if let fileURL = fileInfo.fileURL {
                        Button("Finder에서 열기") {
                            smartFileSearchViewModel.openInFinder(fileURL)
                        }
                    }
                }
            }
        }
    }
}
