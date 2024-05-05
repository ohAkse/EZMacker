//
//  EZMackerApp.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import SwiftUI

@main
struct EZMackerApp: App {
    var body: some Scene {
        WindowGroup {
            MainContentView().frame(minWidth: 100, minHeight: 700)
        }
        .windowToolbarStyle(.unifiedCompact)
        
    }
}
