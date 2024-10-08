//
//  SmartImageTunerViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 9/28/24.
//

import SwiftUI
import EZMackerImageLib
import EZMackerUtilLib
import PencilKit

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
    
    func saveImage(currentDrawing: [NSBezierPath], viewSize: CGSize) {
        guard let capturedImage = captureImageSection(currentDrawing: currentDrawing, viewSize: viewSize) else { return }
        
        let savePanel = NSSavePanel().then {
            $0.allowedContentTypes = [.png]
            $0.canCreateDirectories = true
            $0.isExtensionHidden = false
            $0.title = "Save Image"
            $0.message = "Choose a location to save the image"
            $0.nameFieldStringValue = "image.png"
        }
        
        savePanel.begin { result in
            if result == .OK, let url = savePanel.url {
                let finalImage: NSImage
                
                if self.displayMode == .fillFrame {
                    finalImage = capturedImage.resize(to: viewSize)
                } else {
                    finalImage = capturedImage
                }
                
                if let tiffRepresentation = finalImage.tiffRepresentation,
                   let bitmapImage = NSBitmapImageRep(data: tiffRepresentation),
                   let pngData = bitmapImage.representation(using: .png, properties: [:]) {
                    do {
                        try pngData.write(to: url)
                        Logger.writeLog(.info, message: "Image saved successfully")
                    } catch {
                        Logger.writeLog(.error, message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func captureImageSection(currentDrawing: [NSBezierPath], viewSize: CGSize) -> NSImage? {
        guard let image = self.image,
              viewSize.width > 0, viewSize.height > 0,
              image.size.width > 0, image.size.height > 0 else { return nil }

        let imageSize = image.size
        let newImage = NSImage(size: imageSize)

        newImage.lockFocus()

        image.draw(in: NSRect(origin: .zero, size: imageSize))

        NSColor.black.set()
        for path in currentDrawing {
            if let scaledPath = path.copy() as? NSBezierPath {
                let scaleX = imageSize.width / viewSize.width
                let scaleY = imageSize.height / viewSize.height
                
                // 유효성 검사 추가
                guard scaleX.isFinite && scaleY.isFinite && scaleX > 0 && scaleY > 0 else {
                    print("zz")
                    continue
                }
                
                scaledPath.transform(using: AffineTransform(scaleByX: scaleX, byY: scaleY))
                scaledPath.lineWidth = max(1, 5 * min(scaleX, scaleY)) // 최소 1의 두께 보장
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
