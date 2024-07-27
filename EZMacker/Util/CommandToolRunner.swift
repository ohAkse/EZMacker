//
//  CommandToolRunner.swift
//  EZMacker
//
//  Created by 박유경 on 5/27/24.
//

//https://ss64.com/mac/
import Foundation
import AppKit

//다운로드, 사진, 그림, 영화, 음악 등 기본적으로 제한
struct CommandToolRunner {
    static let shared = CommandToolRunner()
    
    func runMDFind(searchText: String, fileType: String? = nil, completion: @escaping (String?) -> Void) {
        let fileManager = FileManager.default
        
        let accessibleFolders: [FileManager.SearchPathDirectory] = [
              .downloadsDirectory,
              .picturesDirectory,
              .musicDirectory,
              .moviesDirectory
          ]
        
        let folderURLs = accessibleFolders.compactMap {
            fileManager.urls(for: $0, in: .userDomainMask).first
        }
        
        var results = [String]()
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.example.resultsQueue")
        
        for folderURL in folderURLs {
            group.enter()
            
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/mdfind")
            
            var query: String
            if let fileType = fileType {
                query = "kMDItemDisplayName == '*\(searchText)*'cd && kMDItemKind == '\(fileType)'cd"
            } else {
                query = "kMDItemDisplayName == '*\(searchText)*'cd"
            }
            
            process.arguments = [query, "-onlyin", folderURL.path]
            
            let pipe = Pipe()
            process.standardOutput = pipe
            process.standardError = pipe
            
            process.terminationHandler = { _ in
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8), !output.isEmpty {
                    queue.sync {
                        results.append(output)
                    }
                }
                group.leave()
            }
            
            do {
                try process.run()
            } catch {
                Logger.writeLog(.error, message: "mdfind error for \(folderURL.lastPathComponent): \(error.localizedDescription)")
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            let combinedResults = results.joined(separator: "\n")
            if !combinedResults.isEmpty {
                Logger.writeLog(.info, message: "mdfind output: \(combinedResults)")
                completion(combinedResults)
            } else {
                Logger.writeLog(.info, message: "mdfind produced no output.")
                completion(nil)
            }
        }
    }
}
