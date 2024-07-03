//
//  AppSmartFileService.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import Combine
import SwiftUI
import QuickLookThumbnailing

protocol AppSmartFileProvidable {
    func getFileInfo(fileUrl: URL) -> Future<(String, UInt64, String, URL), Error>
    func getThumbnail(for url: URL) -> Future<NSImage, Error>
}

struct AppSmartFileService: AppSmartFileProvidable {
    
    func getFileInfo(fileUrl: URL) -> Future<(String, UInt64, String, URL), Error> {
        return Future { promise in
            let fileManager = FileManager.default
            do {
                let attributes = try fileManager.attributesOfItem(atPath: fileUrl.path)
                let fileName = fileUrl.lastPathComponent
                let fileSize = attributes[.size] as? UInt64 ?? 0
                let fileType = attributes[.type] as? String ?? "Unknown"
                promise(.success((fileName, fileSize, fileType, fileUrl)))
            } catch {
                Logger.writeLog(.error, message: "Error reading file attributes: \(error.localizedDescription)")
                promise(.failure(error))
            }
        }
    }
    
    func getThumbnail(for url: URL) -> Future<NSImage, Error> {
        return Future { promise in
            let size = CGSize(width: 100, height: 100)
            let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: 1.0, representationTypes: .all)
            
            QLThumbnailGenerator.shared.generateBestRepresentation(for: request) { (thumbnail, error) in
                if let error = error {
                    promise(.failure(error))
                } else if let nsImage = thumbnail?.nsImage {
                    promise(.success(nsImage))
                } else {
                    promise(.failure(NSError(domain: "ThumbnailError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to generate thumbnail"])))
                }
            }
        }
    }
}
