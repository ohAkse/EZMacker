//
//  FileInfo.swift
//  EZMacker
//
//  Created by 박유경 on 7/3/24.
//

import SwiftUI
import AppKit

struct FileInfo: Codable, Identifiable {
    var id = UUID()
    var fileName: String = ""
    var fileSize: Int64 = 0
    var fileType: String = ""
    var fileURL: URL?
    var thumbNailData: Data?
    var securityScopeBookmark: Data?
    var tab: String = ""
    var modificationDate: Date?

    var thumbNail: NSImage? {
        get {
            guard let data = thumbNailData else { return nil }
            return NSImage(data: data)
        }
        set {
            thumbNailData = newValue?.tiffRepresentation
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, fileName, fileSize, fileType, fileURL, thumbNailData, securityScopeBookmark, tab, modificationDate
    }

    init(fileName: String = "", fileSize: Int64 = 0, fileType: String = "", fileURL: URL? = nil, thumbNail: NSImage? = nil, tab: String = "", modificationDate: Date? = nil) {
        self.id = UUID()
        self.fileName = fileName
        self.fileSize = fileSize
        self.fileType = fileType
        self.fileURL = fileURL
        self.thumbNail = thumbNail
        self.tab = tab
        self.modificationDate = modificationDate
    }

    static let empty = FileInfo()
}
