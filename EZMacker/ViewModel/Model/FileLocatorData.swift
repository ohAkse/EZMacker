//
//  FileLocatorData.swift
//  EZMacker
//
//  Created by 박유경 on 7/13/24.
//
import Foundation

struct FileLocatorData: Codable {
    var tabs: [String]
    var selectedTab: String?
    var fileViewsPerTab: [String: [UUID: FileData]]
}
