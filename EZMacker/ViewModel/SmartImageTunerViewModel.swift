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
    @Published var currentImage: NSImage?
    @Published var displayMode: ImageDisplayMode = .keepAspectRatio
    @Published private(set) var isProcessing = false
    @Published private(set) var hasChanges: Bool = false
    @Published private(set) var currentFilter: FilterType?
    
    private let imageSenderWrapper: ImageProcessWrapperProvidable
    private let textRenderingOffset: CGFloat = 5
    
    func setUploadImage(_ newImage: NSImage) {
        self.originImage = newImage
        self.currentImage = newImage
        self.hasChanges = false
        self.currentFilter = nil
    }
    
    func setDisplayMode(_ mode: ImageDisplayMode) {
        displayMode = mode
    }
    
    private func captureImageSection(currentPenSetting: PenToolSetting, textOverlays: [TextItem], viewSize: CGSize) -> NSImage? {
        guard let image = self.currentImage,
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
        context.then {
            $0.setShouldAntialias(true)
            $0.interpolationQuality = .high
        }
        
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
        
        for overlay in textOverlays {
            let nsColor = NSColor(overlay.color)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left

            let attributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: overlay.fontSize),
                .foregroundColor: nsColor,
                .paragraphStyle: NSMutableParagraphStyle()
            ]
            
            let attributedString = NSAttributedString(string: overlay.text, attributes: attributes)
            let textRect = CGRect(
                x: (overlay.position.x - overlay.size.width / 2) + textRenderingOffset,
                y: viewSize.height - overlay.position.y - overlay.size.height + textRenderingOffset,
                width: overlay.size.width,
                height: overlay.size.height
            )
            attributedString.draw(in: textRect)
        }
        
        context.restoreGState()
        newImage.unlockFocus()
        return newImage
    }
    
    func saveImage(currentDrawing: PenToolSetting, textOverlays: [TextItem], viewSize: CGSize, completion: @escaping (SaveImageResult) -> Void) {
        let savePanel = NSSavePanel().then {
            $0.allowedContentTypes = [.png]
            $0.canCreateDirectories = true
            $0.isExtensionHidden = false
            $0.title = "사진 저장하기"
            $0.message = "사진 저장할 위치를 정해주세요."
            $0.nameFieldStringValue = ""
        }
        
        savePanel.begin { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .OK:
                guard let url = savePanel.url,
                      let _ = originImage else {
                    completion(.error("Failed to get save URL or original image"))
                    return
                }
                
                guard let capturedImage = self.captureImageSection(currentPenSetting: currentDrawing, textOverlays: textOverlays, viewSize: viewSize) else {
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
}

extension SmartImageTunerViewModel {
    func updateEditState(image: NSImage) {
        self.currentImage = image
        self.hasChanges = true
    }

    func resetImage() {
        if let originalImage = originImage {
            self.currentImage = originalImage
            self.hasChanges = false
        }
    }

    func hasImageChanges() -> Bool {
        return hasChanges
    }
    
    func rotateImage(rotateType: RotateType) {
        guard let currentImage = self.currentImage else { return }
        isProcessing = true
        
        imageSenderWrapper.rotateImageAsync(currentImage, rotateType: rotateType) { [weak self] rotatedImage, error in
            guard let self = self else { return }
            if let rotatedImage = rotatedImage {
                self.currentImage = rotatedImage
                self.hasChanges = true
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
            self.isProcessing = false
        }
    }
    
    func flipImage(flipType: FlipType) {
        guard let currentImage = self.currentImage else { return }
        isProcessing = true
        
        imageSenderWrapper.flipImageAsync(currentImage, flipType: flipType) { [weak self] flippedImage, error in
            guard let self = self else { return }
            if let flippedImage = flippedImage {
                self.currentImage = flippedImage
                self.hasChanges = true
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
            self.isProcessing = false
        }
    }
    
    func filterImage(filterType: FilterType) {
        guard let currentImage = self.currentImage else { return }
        
        if currentFilter == filterType {
            return
        }

        isProcessing = true
        imageSenderWrapper.filterImageAsync(currentImage, filterType: filterType) { [weak self] filteredImage, error in
            guard let self = self else { return }
            
            if let filteredImage = filteredImage {
                self.currentImage = filteredImage
                self.currentFilter = filterType
                self.hasChanges = true
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
            self.isProcessing = false
        }
    }
}
