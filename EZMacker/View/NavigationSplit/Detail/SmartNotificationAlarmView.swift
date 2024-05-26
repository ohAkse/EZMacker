//
//  NotificationAlarmView.swift
//  EZMacker
//
//  Created by 박유경 on 5/13/24.
//

import SwiftUI
struct SmartNotificationAlarmView: View {
    @EnvironmentObject var colorSchemeViewModel: ColorSchemeViewModel
    @ObservedObject var smartNotificationAlarmViewModel: SmartNotificationAlarmViewModel
    @State private var toast: Toast?

    var body: some View {
        VStack {
            Text(CategoryType.smartNotificationAlarm.title)
                .customNormalTextFont(fontSize: FontSizeType.small.size, isBold: false)
        }
        .navigationTitle(CategoryType.smartNotificationAlarm.title)
        .padding()
    }
}
