//
//  NotificationAlarmKey.swift
//  EZMacker
//
//  Created by 박유경 on 9/17/24.
//

enum NotificationAlarmKey: String {
    case batterySetting
    case wifiSetting
    case fileLocatorSetting

    var value: String { self.rawValue }
}
