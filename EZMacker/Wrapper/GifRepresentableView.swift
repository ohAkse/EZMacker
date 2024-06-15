//
//  GifRepresentableView.swift
//  EZMacker
//
//  Created by 박유경 on 6/11/24.
//

import SwiftUI
import AppKit

struct GifRepresentableView: NSViewRepresentable {
    let gifName: String
    let imageSize: CGSize
    
    func makeNSView(context: Context) -> NSImageView {
        let imageView = NSImageView()
        if let gifURL = Bundle.main.url(forResource: gifName, withExtension: "gif"),
           let gifData = try? Data(contentsOf: gifURL) {
            let gifImage = NSImage(data: gifData)
            gifImage?.size = imageSize
            imageView.image = gifImage
        }
        imageView.imageScaling = .scaleProportionallyUpOrDown
        return imageView
    }
    
    func updateNSView(_ nsView: NSImageView, context: Context) {
    }
}

