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
            fileSearchSectionView
            fileResultSectionView
        }
        .navigationTitle(CategoryType.smartFileSearch.title)
        .padding(30)
    }
    //MARK: 검색 입력 섹션
    private var fileSearchSectionView: some View {
        HStack {
            TextField("찾고자 하는 파일 이름을 검색하여 주세요.", text: $smartFileSearchViewModel.searchText)
                .padding(.leading, 10)
                .frame(height: 45)
                .ezTextFieldStyle()
            Button("검색") {
                [weak smartFileSearchViewModel] in
                smartFileSearchViewModel?.searchFileList()
            }
            .frame(width: 55, height: 45)
            .ezButtonStyle()
        }
    }
    
    //MARK: 검색 결과창 섹션
    private var fileResultSectionView: some View {
        Group {
            if smartFileSearchViewModel.searchResults.isEmpty {
                Text("검색된 결과가 없습니다.")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ezListViewStyle()
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("총 \(smartFileSearchViewModel.searchResults.count)개의 파일이 검색되었습니다.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.leading, 10)
                    
                    List(smartFileSearchViewModel.searchResults, id: \.id) { fileInfo in
                        VStack(alignment: .leading) {
                            Text(fileInfo.fileName)
                                .font(.headline)
                                .lineLimit(1)
                            if let fileURL = fileInfo.fileURL {
                                Text(fileURL.path)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                    .truncationMode(.middle)
                            }
                            HStack {
                                HStack(spacing: 8) {
                                    Text("타입: \(fileInfo.fileType.converFileType())")
                                    Text(ByteCountFormatter.string(fromByteCount: fileInfo.fileSize, countStyle: .file))
                                }
                                Spacer()
                                HStack(spacing: 8) {
                                    if let modDate = fileInfo.modificationDate {
                                        Text("수정일: \(modDate.getCurrentTime())")
                                    }
                                    if let creationDate = fileInfo.creationDate {
                                        Text("생성일: \(creationDate.getCurrentTime())")
                                    }
                                }
                            }
                        }
                        .padding(5)
                        .ezListRowStyle()
                        .contextMenu {
                            if let fileURL = fileInfo.fileURL {
                                Button("Finder에서 열기") {
                                    smartFileSearchViewModel.openInFinder(fileURL)
                                }
                            }
                            Menu("이름순으로 정렬") {
                                Button("이름 기준으로 오름차순 정렬") {
                                    smartFileSearchViewModel.sortByName(isAscending: true)
                                }
                                Button("이름 기준으로 내림차순 정렬") {
                                    smartFileSearchViewModel.sortByName(isAscending: false)
                                }
                            }
                            Menu("생성일순으로 정렬") {
                                Button("생성일 기준으로 오름차순 정렬") {
                                    smartFileSearchViewModel.sortByCreationDate(isAscending: true)
                                }
                                Button("생성일 기준으로 내림차순 정렬") {
                                    smartFileSearchViewModel.sortByCreationDate(isAscending: false)
                                }
                            }
                        }
                    }
                    .ezListViewStyle()
                }
            }
        }
    }
}
