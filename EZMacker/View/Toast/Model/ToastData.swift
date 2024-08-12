//
//  Toast.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import Foundation

struct ToastData: Equatable {
    var type: ToastType
    var title: String
    var message: String
    var duration: Double = 3
}
