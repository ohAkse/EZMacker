//
//  EZTextEditorView.swift
//  EZMacker
//
//  Created by 박유경 on 11/2/24.
//

import SwiftUI

struct EZTextEditorView: View {
    @Binding var textItem: TextItem
    @GestureState private var dragOffset: CGSize = .zero
    @GestureState private var resizeOffset: CGSize = .zero
    private let onUpdate: (TextItem) -> Void
    private let onDelete: () -> Void
    private let onConfirm: (TextItem) -> Void

    private let minWidth: CGFloat = 150
    private let minHeight: CGFloat = 100
    private let maxWidth: CGFloat = 400
    private let maxHeight: CGFloat = 300

    init(textItem: Binding<TextItem>,
         onUpdate: @escaping (TextItem) -> Void,
         onDelete: @escaping () -> Void,
         onConfirm: @escaping (TextItem) -> Void) {
        self._textItem = textItem
        self.onUpdate = onUpdate
        self.onDelete = onDelete
        self.onConfirm = onConfirm
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(textItem.isEditing ? Color.gray.opacity(0.2) : Color.clear)
                .cornerRadius(5)
                .frame(width: adjustedWidth, height: adjustedHeight)
            
            VStack(spacing: 0) {
                HStack {
                    if textItem.isEditing {
                        Button(action: onDelete) {
                            Image(systemName: "trash")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(4)
                        
                        Spacer()
                        
                        Button(action: confirmEdit) {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.green)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(4)
                    }
                }
                .frame(height: 30)
                .background(textItem.isEditing ? Color.blue : Color.clear)

                ZStack(alignment: .topLeading) {
                    if textItem.isEditing {
                        TextEditor(text: $textItem.text)
                            .font(.system(size: textItem.fontSize))
                            .foregroundColor(textItem.color)
                            .padding(.zero)
                            .lineLimit(nil)
                            .frame(width: adjustedWidth, height: adjustedHeight - 30)
                            .background(Color.clear)
                            .scrollContentBackground(.hidden)
                    } else {
                        Text(textItem.text)
                            .font(.system(size: textItem.fontSize))
                            .foregroundColor(textItem.color)
                            .frame(width: adjustedWidth, height: adjustedHeight - 30, alignment: .topLeading)
                            .onTapGesture {
                                textItem.isEditing = true
                            }
                    }
                }
            }
            .frame(width: adjustedWidth, height: adjustedHeight)

            if textItem.isEditing {
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                    .foregroundColor(.gray)
                    .frame(width: adjustedWidth, height: adjustedHeight)

                ResizeAnchorView
                    .frame(width: adjustedWidth, height: adjustedHeight)
            }
        }
        .position(x: textItem.position.x + dragOffset.width, y: textItem.position.y + dragOffset.height)
        .gesture(dragGesture)
    }

    private var adjustedWidth: CGFloat {
        max(minWidth, min(maxWidth, textItem.size.width + resizeOffset.width))
    }

    private var adjustedHeight: CGFloat {
        max(minHeight, min(maxHeight, textItem.size.height + resizeOffset.height))
    }

    private var ResizeAnchorView: some View {
        ZStack {
            ForEach(ResizeItem.allCases, id: \.self) { resizeItem in
                EZResizeAnchorView()
                    .position(locatePosition(for: resizeItem, width: adjustedWidth, height: adjustedHeight))
                    .gesture(resizeAnchorGesture(for: resizeItem))
            }
        }
    }

    private func locatePosition(for resizeItem: ResizeItem, width: CGFloat, height: CGFloat) -> CGPoint {
        switch resizeItem {
        case .topLeft: return CGPoint(x: 0, y: 0)
        case .topRight: return CGPoint(x: width, y: 0)
        case .bottomLeft: return CGPoint(x: 0, y: height)
        case .bottomRight: return CGPoint(x: width, y: height)
        }
    }

    private func confirmEdit() {
        textItem.size.width = adjustedWidth
        textItem.size.height = adjustedHeight
        textItem.isEditing = false
        onConfirm(textItem)
    }
}

extension EZTextEditorView {
    private var dragGesture: some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, _ in
                state = value.translation
            }
            .onEnded { value in
                if textItem.isEditing {
                    textItem.position.x += value.translation.width
                    textItem.position.y += value.translation.height
                    onUpdate(textItem)
                }
            }
    }
    private func resizeAnchorGesture(for handle: ResizeItem) -> some Gesture {
        DragGesture()
            .updating($resizeOffset) { value, state, _ in
                var newWidth = textItem.size.width
                var newHeight = textItem.size.height
                switch handle {
                case .topLeft:
                    newWidth = max(minWidth, textItem.size.width - value.translation.width)
                    newHeight = max(minHeight, textItem.size.height - value.translation.height)
                case .topRight:
                    newWidth = min(maxWidth, textItem.size.width + value.translation.width)
                    newHeight = max(minHeight, textItem.size.height - value.translation.height)
                case .bottomLeft:
                    newWidth = max(minWidth, textItem.size.width - value.translation.width)
                    newHeight = min(maxHeight, textItem.size.height + value.translation.height)
                case .bottomRight:
                    newWidth = min(maxWidth, textItem.size.width + value.translation.width)
                    newHeight = min(maxHeight, textItem.size.height + value.translation.height)
                }
                state = CGSize(width: newWidth - textItem.size.width, height: newHeight - textItem.size.height)
            }
            .onEnded { value in
                if textItem.isEditing {
                    switch handle {
                    case .topLeft:
                        textItem.size.width = max(minWidth, textItem.size.width - value.translation.width)
                        textItem.size.height = max(minHeight, textItem.size.height - value.translation.height)
                    case .topRight:
                        textItem.size.width = min(maxWidth, textItem.size.width + value.translation.width)
                        textItem.size.height = max(minHeight, textItem.size.height - value.translation.height)
                    case .bottomLeft:
                        textItem.size.width = max(minWidth, textItem.size.width - value.translation.width)
                        textItem.size.height = min(maxHeight, textItem.size.height + value.translation.height)
                    case .bottomRight:
                        textItem.size.width = min(maxWidth, textItem.size.width + value.translation.width)
                        textItem.size.height = min(maxHeight, textItem.size.height + value.translation.height)
                    }
                    onUpdate(textItem)
            }
        }
    }
}
