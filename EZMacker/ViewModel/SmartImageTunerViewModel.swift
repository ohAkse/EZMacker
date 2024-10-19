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
    @Published var image: NSImage?
    @Published var displayMode: ImageDisplayMode = .keepAspectRatio
    
    private let imageSenderWrapper: ImageProcessWrapperProvidable
    
    func setImage(_ newImage: NSImage) {
        self.image = newImage
    }
    func setDisplayMode(_ mode: ImageDisplayMode) {
        displayMode = mode
    }
    
    func saveImage(currentDrawing: PenToolSetting, viewSize: CGSize, completion: @escaping (Bool) -> Void) {
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
            
            guard let capturedImage = self.captureImageSection(currentPenSetting: currentDrawing, viewSize: viewSize) else {
                completion(false)
                return
            }
            
            if result == .OK, let url = savePanel.url {
                let finalImage: NSImage
                
                if displayMode == .fillFrame {
                    finalImage = capturedImage.resize(to: viewSize)
                } else {
                    finalImage = capturedImage
                }
                
                if let tiffRepresentation = finalImage.tiffRepresentation,
                   let bitmapImage = NSBitmapImageRep(data: tiffRepresentation),
                   let pngData = bitmapImage.representation(using: .png, properties: [:]) {
                    do {
                        try pngData.write(to: url)
                        completion(true)
                    } catch {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    private func captureImageSection(currentPenSetting: PenToolSetting, viewSize: CGSize) -> NSImage? {
        guard let image = self.image,
              viewSize.width > 0, viewSize.height > 0,
              image.size.width > 0, image.size.height > 0 else { return nil }
        
        let imageSize = image.size
        let newImage = NSImage(size: imageSize)
        
        newImage.lockFocus()

        image.draw(in: NSRect(origin: .zero, size: imageSize))
        
        for stroke in currentPenSetting.penStrokes {
            if let scaledPath = stroke.penPath.copy() as? NSBezierPath {
                let scaleX = imageSize.width / viewSize.width
                let scaleY = imageSize.height / viewSize.height
                
                guard scaleX.isFinite && scaleY.isFinite && scaleX > 0 && scaleY > 0 else {
                    continue
                }

                scaledPath.transform(using: AffineTransform(scaleByX: scaleX, byY: scaleY))
                
                let nsColor = NSColor(stroke.penColor)
                nsColor.set()
                
                scaledPath.lineWidth = max(1, stroke.penThickness * min(scaleX, scaleY))
                scaledPath.stroke()
            }
        }
        
        newImage.unlockFocus()
        return newImage
    }
}
// CallBack Result From Native
extension SmartImageTunerViewModel {
    func bindNativeOutput() {
        // MARK: ReceiverTest
        imageSenderWrapper.setInt64callback { [weak self] newValue in
            guard let _ = self else { return }
            DispatchQueue.main.async {
                Logger.writeLog(.info, message: "Received updated value from C++: \(newValue)")
            }
        }
    }
    func setInt64() {
        var num: Int64 = 5
        self.imageSenderWrapper.updateNativeValue(inOut: &num)
    }
}
