//
//  FileManager + Extension.swift
//  EZMacker
//
//  Created by 박유경 on 8/18/24.
//

import Foundation

extension FileManager {
    func isDirectory(url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        _ = fileExists(atPath: url.path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
}
