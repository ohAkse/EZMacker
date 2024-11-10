//
//  AppSmartFileService.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 9/1/24.
//

import Combine
import SwiftUI
import QuickLookThumbnailing
import EZMackerUtilLib

public protocol AppSmartFileProvidable {
    func getFileInfo(fileUrl: URL) -> Future<(String, Int64, String, URL, Date?), Error>
    func getThumbnail(for url: URL) -> Future<NSImage, Error>
}

public struct AppSmartFileService: AppSmartFileProvidable {
    public init() {}
    public func getFileInfo(fileUrl: URL) -> Future<(String, Int64, String, URL, Date?), Error> {
        return Future { promise in
            let fileManager = FileManager.default
            do {
                let attributes = try fileManager.attributesOfItem(atPath: fileUrl.path)
                var fileName = fileUrl.lastPathComponent
                if fileName.hasSuffix(".app") {
                    fileName = String(fileName.dropLast(4))
                }
                let fileSize = attributes[.size] as? Int64 ?? 0
                var fileType = AppFileDescriptionType(type: attributes[.type] as? String ?? AppFileDescriptionType.unknown.rawValue).name
                
                if fileType == "폴더", fileUrl.pathExtension == "app" {
                    fileType = "응용 프로그램"
                }
                
                let modificationDate = attributes[.modificationDate] as? Date
                
                promise(.success((fileName, fileSize, fileType, fileUrl, modificationDate)))
                
            } catch {
                Logger.writeLog(.error, message: "Error reading file attributes: \(error.localizedDescription)")
                promise(.failure(error))
            }
        }
    }

    public func getThumbnail(for url: URL) -> Future<NSImage, Error> {
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
