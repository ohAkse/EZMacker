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
    private var frameSize: CGSize = .zero
    private let imageSenderWrapper: ImageProcessWrapperProvidable
    
    func setImage(_ newImage: NSImage) {
        self.image = newImage
    }
    func setDisplayMode(_ mode: ImageDisplayMode) {
        displayMode = mode
    }
    func updateFrameSize(_ size: CGSize) {
        frameSize = size
    }
    func saveImage(with drawing: [NSBezierPath]) {
        guard let image = image else { return }
        
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.png]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.title = "Save Image"
        savePanel.message = "Choose a location to save the image"
        savePanel.nameFieldStringValue = "image.png"
        
        savePanel.begin { result in
            if result == .OK, let url = savePanel.url {
                let savedImage: NSImage
                if self.displayMode == .fillFrame {
                    savedImage = image.resize(to: self.frameSize)
                } else {
                    savedImage = image
                }
                
                let finalImage = self.drawingOnImage(savedImage, drawing: drawing)
                
                if let tiffData = finalImage.tiffRepresentation,
                   let bitmapImage = NSBitmapImageRep(data: tiffData),
                   let pngData = bitmapImage.representation(using: .png, properties: [:]) {
                    do {
                        try pngData.write(to: url)
                        print("Image saved successfully")
                    } catch {
                        print("Error saving image: \(error)")
                    }
                }
            }
        }
    }

    private func drawingOnImage(_ image: NSImage, drawing: [NSBezierPath]) -> NSImage {
        let imageSize = image.size
        let finalImage = NSImage(size: imageSize)
        
        finalImage.lockFocus()
        
        // 원본 이미지 그리기
        image.draw(in: NSRect(origin: .zero, size: imageSize))
        
        // 드로잉 그리기
        NSColor.black.set()
        for path in drawing {
            path.lineWidth = 5
            path.stroke()
        }
        
        finalImage.unlockFocus()
        
        return finalImage
    }
}
// CallBack Result From Native
extension SmartImageTunerViewModel {
    func bindNativeOutput() {
        // MARK: ReceiverTest
        imageSenderWrapper.setInt64callback { newValue in
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
