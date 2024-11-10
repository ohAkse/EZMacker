//
//  AppNotificationCenter.swift
//  EZMacker
//
//  Created by 박유경 on 5/26/24.
//

import UserNotifications
import EZMackerUtilLib

class AppNotificationManager {
    static let shared = AppNotificationManager()

    func sendNotification(title: String, subtitle: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 에러: \(error.localizedDescription)")
            }
        }
    }
}
