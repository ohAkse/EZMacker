//
//  SmartFileSearchViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 7/5/24.
//

import Combine
import AppKit

class SmartFileSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResults: [FileData] = []
    
    deinit {
        Logger.writeLog(.debug, message: "SmartFileSearchViewModel deinit Called")
    }
    func searchFileList() {
        let queries: [MDFindQuery] = [.name(searchText)]
        var folderURLs: [URL] = []

        let commonFolders: [FileManager.SearchPathDirectory] = [
            .downloadsDirectory,
            .picturesDirectory,
            .musicDirectory,
            .moviesDirectory
        ]
        folderURLs.append(contentsOf: commonFolders.compactMap {
            FileManager.default.urls(for: $0, in: .userDomainMask).first
        })

        if !AppEnvironment.shared.isSandboxed {
            let additionalFolders: [FileManager.SearchPathDirectory] = [
                .documentDirectory,
                .desktopDirectory
            ]
            folderURLs.append(URL(fileURLWithPath: "/Users"))
            folderURLs.append(contentsOf: additionalFolders.compactMap {
                FileManager.default.urls(for: $0, in: .userDomainMask).first
            })
        }

        let command = MDFindCommand.find(queries, folderURLs: folderURLs)
        CommandToolRunner.shared.runCommand(command: command) { [weak self] result in
            if let result = result {
                self?.processSearchResults(result)
            } else {
                self?.searchResults = []
            }
        }
    }

    private func processSearchResults(_ output: String) {
        let fileManager = FileManager.default
        let paths = Set(output.components(separatedBy: .newlines).filter { !$0.isEmpty })
        
        searchResults = paths.compactMap { path -> FileData? in
            guard let attributes = try? fileManager.attributesOfItem(atPath: path) else { return nil }
            
            let fileURL = URL(fileURLWithPath: path)
            let fileName = fileURL.lastPathComponent
            let fileSize = (attributes[.size] as? NSNumber)?.int64Value ?? 0
            let fileType = (attributes[.type] as? String) ?? ""
            let modificationDate = attributes[.modificationDate] as? Date
            let creationDate = attributes[.creationDate] as? Date
            
            return FileData(fileName: fileName,
                            fileSize: fileSize,
                            fileType: fileType,
                            fileURL: fileURL,
                            modificationDate: modificationDate,
                            creationDate: creationDate)
        }
    }
    func sortByName(isAscending: Bool) {
        searchResults.sort {
            isAscending ? $0.fileName < $1.fileName : $0.fileName > $1.fileName
        }
    }
    
    func sortByCreationDate(isAscending: Bool) {
        searchResults.sort { (file1, file2) -> Bool in
            guard let date1 = file1.creationDate, let date2 = file2.creationDate else {
                return false
            }
            return isAscending ? date1 < date2 : date1 > date2
        }
    }
    func openInFinder(_ fileURL: URL) {
        NSWorkspace.shared.activateFileViewerSelecting([fileURL])
    }
}
