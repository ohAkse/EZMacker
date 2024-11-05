//
//  ResizeItem.swift
//  EZMacker
//
//  Created by 박유경 on 11/3/24.
//

import Foundation
enum ResizeItem: CaseIterable, Identifiable {
    case topLeft, topRight, bottomLeft, bottomRight
    var id: Self { self }
}
