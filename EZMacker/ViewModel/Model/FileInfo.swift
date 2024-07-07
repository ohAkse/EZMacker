//
//  FileInfo.swift
//  EZMacker
//
//  Created by 박유경 on 7/3/24.
//

import SwiftUI

struct FileInfo: Codable {
    var fileName: String = ""
    var fileSize: UInt64 = 0
    var fileType: String = ""
    var fileURL: URL?
    var thumbNailData: Data?
    var securityScopeBookmark: Data?
    var tab: String = "" 
    
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
        case fileName, fileSize, fileType, fileURL, thumbNailData, securityScopeBookmark, tab  // tab을 추가합니다.
    }
    
    init(fileName: String = "", fileSize: UInt64 = 0, fileType: String = "", fileURL: URL? = nil, thumbNail: NSImage? = nil, tab: String = "") {
        self.fileName = fileName
        self.fileSize = fileSize
        self.fileType = fileType
        self.fileURL = fileURL
        self.thumbNail = thumbNail
        self.tab = tab  // 이 줄을 추가합니다.
    }
    
    static let empty = FileInfo()
}
