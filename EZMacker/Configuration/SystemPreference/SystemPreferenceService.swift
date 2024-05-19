//
//  SystemPreferenceService.swift
//  EZMacker
//
//  Created by 박유경 on 5/19/24.
//

import SwiftUI
protocol SystemPreferenceAccessible {
    func openSystemPreferences(systemPath: String)
}


struct SystemPreferenceService: SystemPreferenceAccessible {
    func openSystemPreferences(systemPath: String) {
        guard let url = URL(string: systemPath) else {
            return
        }
        NSWorkspace.shared.open(url)
    }
}
