//
//  AppNotificationCenter.swift
//  EZMacker
//
//  Created by 박유경 on 5/26/24.
//

import UserNotifications
class AppNotificationManager {
    static let shared = AppNotificationManager()

    func sendNotification(title: String, subtitle: String) {
        let content = UNMutableNotificationContent().then {
            $0.title = title
            $0.subtitle = subtitle
            $0.sound = UNNotificationSound.default
        }

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                Logger.writeLog(.error, message: "알림을 보내는 동안 오류가 발생했습니다: \(error.localizedDescription)")
            } 
        }
    }
}
