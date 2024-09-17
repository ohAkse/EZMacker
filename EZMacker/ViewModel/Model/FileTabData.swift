//
//  FileLocatorData.swift
//  EZMacker
//
//  Created by 박유경 on 7/13/24.
//

import Foundation

struct FileTabData: Codable {
    var tabs: [String]
    var selectedTab: String?
    var fileViewsPerTab: [String: [UUID: FileQueryData]]
    
    init(tabs: [String] = [], selectedTab: String? = nil, fileViewsPerTab: [String: [UUID: FileQueryData]] = [:]) {
        self.tabs = tabs
        self.selectedTab = selectedTab
        self.fileViewsPerTab = fileViewsPerTab
    }
}
