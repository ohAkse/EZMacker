//
//  ImageSenderWrapper.swift
//  EZMackerImageLib
//
//  Created by 박유경 on 9/29/24.
//

import AppKit
import EZMackerUtilLib

public enum ImageProcessError: Error {
    case cgImageCreationFailed
    case dataConversionFailed
    case processingFailed
}
public protocol ImageProcessWrapperProvidable {
    func rotateImageSync(_ image: NSImage, rotateType: RotateType) -> Result<NSImage, ImageProcessError>
    func rotateImageAsync(_ image: NSImage, rotateType: RotateType, completion: @escaping (NSImage?, ImageProcessError?) -> Void)
    func flipImageAsync(_ image: NSImage, flipType: FlipType, completion: @escaping (NSImage?, ImageProcessError?) -> Void)
}

public class ImageProcessWrapper: NSObject, ImageProcessWrapperProvidable {
    private var imageProcessBridge: ImageProcessBridge
    
    public override init() {
        self.imageProcessBridge = ImageProcessBridge()
        super.init()
    }
    // MARK: - Sync 방식(추천X)
    public func rotateImageSync(_ image: NSImage, rotateType: RotateType) -> Result<NSImage, ImageProcessError> {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return .failure(.cgImageCreationFailed)
        }
        
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        guard let imageData = bitmapRep.representation(using: .jpeg, properties: [.compressionFactor: 0.9]) else {
            return .failure(.dataConversionFailed)
        }
        
        if let resultData = imageProcessBridge.rotateImageSync(imageData, rotateType: rotateType),
           let rotatedImage = NSImage(data: resultData) {
            return .success(rotatedImage)
        } else {
            return .failure(.processingFailed)
        }
    }
    // MARK: - Async 방식
    public func rotateImageAsync(_ image: NSImage, rotateType: RotateType, completion: @escaping (NSImage?, ImageProcessError?) -> Void) {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            completion(nil, .cgImageCreationFailed)
            return
        }

        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        guard let imageData = bitmapRep.representation(using: .png, properties: [:]) else {
            completion(nil, .dataConversionFailed)
            return
        }
        imageProcessBridge.rotateImageAsync(imageData, rotateType: rotateType) { [weak self] resultData in
            guard let _ = self else { return }
            if let data = resultData,
               let rotatedImage = NSImage(data: data) {
                completion(rotatedImage, nil)
            } else {
                completion(nil, .processingFailed)
            }
        }
    }
    public func flipImageAsync(_ image: NSImage, flipType: FlipType, completion: @escaping (NSImage?, ImageProcessError?) -> Void) {
         guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
             completion(nil, .cgImageCreationFailed)
             return
         }

         let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
         guard let imageData = bitmapRep.representation(using: .png, properties: [:]) else {
             completion(nil, .dataConversionFailed)
             return
         }

         imageProcessBridge.flipImageAsync(imageData, flipType: flipType) { [weak self] resultData in
              guard let _ = self else { return }
             if let data = resultData,
                let flippedImage = NSImage(data: data) {
                 completion(flippedImage, nil)
             } else {
                 completion(nil, .processingFailed)
             }
         }
     }
}
