//
//  AppAlertManager.swift
//  EZMacker
//
//  Created by 박유경 on 5/26/24.
//

import AppKit

class AppAlertManager {
    static let shared = AppAlertManager()
    
    func showNotificationPermissionDeniedAlert(
        systemPath: String,
        title: String,
        message: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String
    ) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: primaryButtonTitle)
        alert.addButton(withTitle: secondaryButtonTitle)
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            guard let url = URL(string: systemPath) else {
                return
            }
            NSWorkspace.shared.open(url)
        }
    }
}
