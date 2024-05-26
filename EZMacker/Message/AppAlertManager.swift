//
//  AppAlertManager.swift
//  EZMacker
//
//  Created by 박유경 on 5/26/24.
//

import AppKit
class AppAlertManager {

    static let shared = AppAlertManager()
    
    func showNotificationPermissionDeniedAlert(systemPath: String) {
        let alert = NSAlert()
        alert.messageText = "알림 권한 거부됨"
        alert.informativeText = "알림 권한이 거부되었습니다. 알림을 받으려면 시스템 설정에서 알림 권한을 허용해주세요."
        alert.addButton(withTitle: "설정으로 이동")
        alert.addButton(withTitle: "닫기")
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            guard let url = URL(string: systemPath) else {
                return
            }
            NSWorkspace.shared.open(url)
        }
    }

}
