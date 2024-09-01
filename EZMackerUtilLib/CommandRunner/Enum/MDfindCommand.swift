//
//  MDFindCommand.swift
//  EZMackerUtilLib
//
//  Created by 박유경 on 9/1/24.
//

import Foundation

public enum MDFindCommand: CoomandExecutable {
    case find(MDFindQuery, folderURLs: [URL])
    
    public var executableURL: URL {
        return URL(fileURLWithPath: "/usr/bin/mdfind")
    }
    
    public var argumentsList: [[String]] {
        switch self {
        case .find(let query, let folderURLs):
            return folderURLs.map { [query.queryString, "-onlyin", $0.path] }
        }
    }
}

public enum MDFindQuery {
    case name(String)
    
    var queryString: String {
        switch self {
        case .name(let text):
            return "kMDItemDisplayName == '*\(text)*'cd"
        }
    }
}
