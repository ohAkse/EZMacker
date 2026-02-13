//
//  MDFindCommand.swift
//  EZMackerUtilLib
//
//  Created by 박유경 on 9/1/24.
//
import Foundation

public enum MDFindCommand: CommandExecutable {
    case find(MDFindQuery, folderURLs: [URL])
    case findGlobal(MDFindQuery)

    public var executableURL: URL {
        return URL(fileURLWithPath: "/usr/bin/mdfind")
    }

    public var argumentsList: [[String]] {
        switch self {
        case .find(let query, let folderURLs):
            if folderURLs.isEmpty {
                return [[query.queryString]]
            }
            return folderURLs.map { [query.queryString, "-onlyin", $0.path] }
        case .findGlobal(let query):
            return [[query.queryString]]
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
