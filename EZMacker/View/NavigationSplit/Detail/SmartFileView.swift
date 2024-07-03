//
//  SmartFileView.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import SwiftUI
import QuickLookThumbnailing


import SwiftUI
import QuickLookThumbnailing

struct SmartFileView: View {
    @ObservedObject var smartFileViewModel: SmartFileViewModel
    @State private var isTargeted: Bool = false

    var body: some View {
        VStack {
            Text("Drag and Drop a file here")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))

            if let previewImage = smartFileViewModel.fileInfo.thumbNail {
                Image(nsImage: previewImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding()
                    .background(isTargeted ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .onDrop(of: [.fileURL], isTargeted: $isTargeted, perform: dropFile)
                    .onTapGesture(perform: openFile)
            } else {
                Image(systemName: "doc.text")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding()
                    .background(isTargeted ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .onDrop(of: [.fileURL], isTargeted: $isTargeted, perform: dropFile)
                    .onTapGesture(perform: openFile)
            }

            Text("File Name: \(smartFileViewModel.fileInfo.fileName)")
            Text("File Size: \(smartFileViewModel.fileInfo.fileSize) bytes")
            Text("File Type: \(smartFileViewModel.fileInfo.fileType)")
        }
        .padding()
    }

    private func dropFile(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }
        provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
            DispatchQueue.main.async {
                if let data = urlData as? Data,
                   let url = URL(dataRepresentation: data, relativeTo: nil) {
                    smartFileViewModel.setFileInfo(fileURL: url)
                }
            }
        }
        return true
    }

    private func openFile() {
        if let fileURL = smartFileViewModel.fileInfo.fileURL {
            NSWorkspace.shared.open(fileURL)
        }
    }
}
