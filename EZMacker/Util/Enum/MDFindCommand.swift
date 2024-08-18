//
//  MDFindCommand.swift
//  EZMacker
//
//  Created by 박유경 on 8/18/24.
//

import Foundation

enum MDFindCommand: CoomandExecutable {
    case find(MDFindQuery, folderURLs: [URL])
    
    var executableURL: URL {
        return URL(fileURLWithPath: "/usr/bin/mdfind")
    }
    
    var argumentsList: [[String]] {
        switch self {
        case .find(let query, let folderURLs):
            return folderURLs.map { [query.queryString, "-onlyin", $0.path] }
        }
    }
}

enum MDFindQuery {
    case name(String)
    
    var queryString: String {
        switch self {
        case .name(let text):
            return "kMDItemDisplayName == '*\(text)*'cd"
        }
    }
}
