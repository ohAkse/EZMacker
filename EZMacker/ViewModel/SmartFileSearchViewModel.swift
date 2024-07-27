//
//  SmartFileSearchViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 7/5/24.
//

import Combine
import Foundation
import AppKit

class SmartFileSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResults: [FileInfo] = []
    
    func search() {
        CommandToolRunner.shared.runMDFind(searchText: searchText) { [weak self] output in
            DispatchQueue.main.async {
                if let output = output {
                    self?.processSearchResults(output)
                } else {
                    self?.searchResults = []
                }
            }
        }
    }
    
    private func processSearchResults(_ output: String) {
        let fileManager = FileManager.default
        let paths = output.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        searchResults = paths.compactMap { path -> FileInfo? in
            guard let attributes = try? fileManager.attributesOfItem(atPath: path) else { return nil }
            
            let fileURL = URL(fileURLWithPath: path)
            let fileName = fileURL.lastPathComponent
            let fileSize = (attributes[.size] as? NSNumber)?.int64Value ?? 0
            let fileType = (attributes[.type] as? String) ?? ""
            let modificationDate = attributes[.modificationDate] as? Date
            
            return FileInfo(fileName: fileName,
                            fileSize: fileSize,
                            fileType: fileType,
                            fileURL: fileURL,
                            modificationDate: modificationDate)
        }
    }
    
    func openInFinder(_ fileURL: URL) {
        NSWorkspace.shared.activateFileViewerSelecting([fileURL])
    }
}
