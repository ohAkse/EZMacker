//
//  Toast.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import Foundation

struct Toast: Equatable {
    var type: ToastStyle
    var title: String
    var message: String
    var duration: Double = 3
}
