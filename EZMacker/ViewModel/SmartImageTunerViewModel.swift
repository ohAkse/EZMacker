//
//  SmartImageTunerViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 9/28/24.
//

import SwiftUI
import EZMackerImageLib
import EZMackerUtilLib

class SmartImageTunerViewModel: ObservableObject {
    deinit {
        Logger.writeLog(.debug, message: "SmartImageTunerViewModel deinit Called")
    }
    init(imageSenderWrapper: ImageProcessWrapperProvidable) {
        self.imageSenderWrapper = imageSenderWrapper
    }
    @Published var originImage: NSImage?
    @Published var displayMode: ImageDisplayMode = .keepAspectRatio
    
    private let imageSenderWrapper: ImageProcessWrapperProvidable
    
    func setUploadImage(_ newImage: NSImage) {
        self.originImage = newImage
    }
    func setDisplayMode(_ mode: ImageDisplayMode) {
        displayMode = mode
    }
    
    func saveImage(currentDrawing: PenToolSetting, viewSize: CGSize, completion: @escaping (SaveImageResult) -> Void) {
        let savePanel = NSSavePanel().then {
            $0.allowedContentTypes = [.png]
            $0.canCreateDirectories = true
            $0.isExtensionHidden = false
            $0.title = "Save Image"
            $0.message = "Choose a location to save the image"
            $0.nameFieldStringValue = ""
        }
        
        savePanel.begin { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .OK:
                guard let url = savePanel.url else {
                    completion(.error("Failed to get save URL"))
                    return
                }
                
                guard let capturedImage = self.captureImageSection(currentPenSetting: currentDrawing, viewSize: viewSize) else {
                    completion(.error("Failed to capture image"))
                    return
                }
                if let finalCGImage = capturedImage.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                    let bitmapImageRep = NSBitmapImageRep(cgImage: finalCGImage)
                    bitmapImageRep.size = capturedImage.size
                    
                    if let pngData = bitmapImageRep.representation(using: .png, properties: [:]) {
                        do {
                            try pngData.write(to: url)
                            completion(.success)
                        } catch {
                            completion(.error("Failed to write image data: \(error.localizedDescription)"))
                        }
                    } else {
                        completion(.error("Failed to create PNG data"))
                    }
                } else {
                    completion(.error("Failed to get CGImage"))
                }
                
            case .cancel:
                completion(.cancelled)
                
            default:
                completion(.error("Unknown error occurred"))
            }
        }
    }

    private func captureImageSection(currentPenSetting: PenToolSetting, viewSize: CGSize) -> NSImage? {
        guard let image = self.originImage,
              viewSize.width > 0, viewSize.height > 0,
              image.size.width > 0, image.size.height > 0 else { return nil }
        
        let imageSize = image.size
        let newImage = NSImage(size: viewSize)
        
        newImage.lockFocus()
        guard let context = NSGraphicsContext.current?.cgContext else {
            newImage.unlockFocus()
            return nil
        }
        
        context.saveGState()
        context.setShouldAntialias(true)
        context.interpolationQuality = .high
        
        if displayMode == .keepAspectRatio {
            let aspectRatio = min(viewSize.width / imageSize.width, viewSize.height / imageSize.height)
            let scaledSize = CGSize(width: imageSize.width * aspectRatio, height: imageSize.height * aspectRatio)
            let origin = CGPoint(x: (viewSize.width - scaledSize.width) / 2, y: (viewSize.height - scaledSize.height) / 2)
            context.draw(image.cgImage(forProposedRect: nil, context: nil, hints: nil)!, in: CGRect(origin: origin, size: scaledSize))
        } else {
            context.draw(image.cgImage(forProposedRect: nil, context: nil, hints: nil)!, in: CGRect(origin: .zero, size: viewSize))
        }
        
        for stroke in currentPenSetting.penStrokes {
            context
                .applyLineWidth(stroke.penThickness)
                .applyLineCap(stroke.lineCapStyle.cgLineCap)
                .applyLineJoin(stroke.lineJoinStyle.cgLineJoin)
                .applyStrokeColor(stroke.penColor.cgColor ?? .clear)
                .applyPath(stroke.penPath.cgPath)
                .strokePath()
        }
        
        context.restoreGState()
        newImage.unlockFocus()
        return newImage
    }

}

extension SmartImageTunerViewModel {
    func rotateImage(rotateType: RotateType) {
        imageSenderWrapper.rotateImageAsync(originImage!, rotateType: rotateType) { [weak self] rotatedImage, error in
            guard let self = self else { return }
            if let rotateImage = rotatedImage {
                originImage = rotateImage
            } else if let error = error {
                switch error {
                case .cgImageCreationFailed:
                    Logger.writeLog(.error, message: "Failed to create CGImage")
                case .dataConversionFailed:
                    Logger.writeLog(.error, message: "Failed to convert to PNG data")
                case .processingFailed:
                    Logger.writeLog(.error, message: "Failed to process image")
                }
            }
        }
    }
    func flipImage(flipType: FlipType) {
        imageSenderWrapper.flipImageAsync(originImage!, flipType: flipType) { [weak self] flipedImage, error in
            guard let self = self else { return }
            if let flippedImage = flipedImage {
                originImage = flippedImage
            } else if let error = error {
                switch error {
                case .cgImageCreationFailed:
                    Logger.writeLog(.error, message: "Failed to create CGImage")
                case .dataConversionFailed:
                    Logger.writeLog(.error, message: "Failed to convert to PNG data")
                case .processingFailed:
                    Logger.writeLog(.error, message: "Failed to process image")
                }
            }
        }
    }
}
