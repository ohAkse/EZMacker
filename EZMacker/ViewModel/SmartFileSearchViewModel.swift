//
//  SmartFileSearchViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 7/5/24.
//

import Combine
import AppKit

class SmartFileSearchViewModel: ObservableObject {
    
    // MARK: - Publish Variable
    @Published var searchText: String = ""
    @Published var searchResults: [FileQueryData] = []
    
    deinit {
        Logger.writeLog(.debug, message: "SmartFileSearchViewModel deinit Called")
    }
    
    // MARK: - Component Event Handle
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
    
    func sortByType(folderFirst: Bool) {
        searchResults.sort { (file1, file2) -> Bool in
            let isFolder1 = isFolder(file1)
            let isFolder2 = isFolder(file2)
            
            if isFolder1 != isFolder2 {
                return folderFirst ? isFolder1 : !isFolder1
            }
            return file1.fileName.lowercased() < file2.fileName.lowercased()
        }
    }
    
    func searchFileList() {
        let queries: [MDFindQuery] = [.name(searchText)]
        var folderURLs: [URL] = []
        
        if AppEnvironment.shared.isSandboxed {
            folderURLs = getSandboxFolderURLs()
        } else {
            folderURLs = getNonSandboxFolderURLs()
        }
        
        let command = MDFindCommand.find(queries, folderURLs: folderURLs)
        CommandToolRunner.shared.runCommand(command: command) { [weak self] result in
            if let result = result {
                Logger.writeLog(.info, message: "mdfind output: \(result)")
                self?.processSearchResults(result)
            } else {
                Logger.writeLog(.info, message: "mdfind not found")
                self?.searchResults = []
            }
        }
    }
    // MARK: - Private Funtions
    private func getSandboxFolderURLs() -> [URL] {
        let sandboxFolders: [FileManager.SearchPathDirectory] = [
            .downloadsDirectory,
            .picturesDirectory,
            .musicDirectory,
            .moviesDirectory,
            
        ]
        
        return sandboxFolders.compactMap {
            FileManager.default.urls(for: $0, in: .userDomainMask).first
        }
    }
    
    private func getNonSandboxFolderURLs() -> [URL] {
        var folderURLs: [URL] = []
        
        let allFolders: [FileManager.SearchPathDirectory] = [
            .downloadsDirectory,
            .picturesDirectory,
            .musicDirectory,
            .moviesDirectory,
            .documentDirectory,
            .desktopDirectory,
            .userDirectory
        ]
        
        folderURLs.append(contentsOf: allFolders.compactMap {
            FileManager.default.urls(for: $0, in: .allDomainsMask).first
        })
        
        let userHomeDirectory = FileManager.default.homeDirectoryForCurrentUser.deletingLastPathComponent()
        folderURLs.append(userHomeDirectory)
        
        return folderURLs
    }
    
    private func processSearchResults(_ output: String) {
        let fileManager = FileManager.default
        let paths = Set(output.components(separatedBy: .newlines).filter { !$0.isEmpty })
        
        searchResults = paths.compactMap { path -> FileQueryData? in
            let normalizedPath = path.precomposedStringWithCanonicalMapping
            let fileURL = URL(fileURLWithPath: normalizedPath)
            
            guard let attributes = try? fileManager.attributesOfItem(atPath: normalizedPath) else { return nil }
            
            let fileName = fileManager.displayName(atPath: normalizedPath)
            let fileSize = (attributes[.size] as? NSNumber)?.int64Value ?? 0
            let fileType = (attributes[.type] as? String) ?? ""
            let modificationDate = attributes[.modificationDate] as? Date
            let creationDate = attributes[.creationDate] as? Date
            
            return FileQueryData(fileName: fileName,
                            fileSize: fileSize,
                            fileType: fileType,
                            fileURL: fileURL,
                            modificationDate: modificationDate,
                            creationDate: creationDate)
        }
    }
    private func isFolder(_ file: FileQueryData) -> Bool {
        if file.fileType == "NSFileTypeDirectory" {
            return true
        }
        if let url = file.fileURL, FileManager.default.isDirectory(url: url) {
            return true
        }
        return false
    }
}
