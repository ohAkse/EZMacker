//
//  FileInfo.swift
//  EZMacker
//
//  Created by 박유경 on 7/3/24.
//

import SwiftUI

struct FileInfo {
    var fileName: String
    var fileSize: UInt64
    var fileType: String
    var fileURL: URL?
    var thumbNail: NSImage?
    static let empty = FileInfo(fileName: "No file dropped", fileSize: 0, fileType: "")
}
