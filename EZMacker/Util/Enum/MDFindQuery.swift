//
//  MDFindQuery.swift
//  EZMacker
//
//  Created by 박유경 on 8/17/24.
//

import Foundation

enum MDFindCommand {
    case find([MDFindQuery], folderURLs: [URL])
    
    var executableURL: URL {
        return URL(fileURLWithPath: "/usr/bin/mdfind")
    }
    
    var argumentsList: [[String]] {
        switch self {
        case .find(let queries, let folderURLs):
            let queryString = queries.map { $0.queryString }.joined(separator: " && ")
            return folderURLs.map { [queryString, "-onlyin", $0.path] }
        }
    }
}

enum MDFindQuery {
    case name(String)
    case custom(String)
    
    var queryString: String {
        switch self {
        case .name(let text):
            return "kMDItemDisplayName == '*\(text)*'cd"
        case .custom(let query):
            return query
        }
    }
}
