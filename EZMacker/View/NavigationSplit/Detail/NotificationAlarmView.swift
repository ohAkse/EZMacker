//
//  NotificationAlarmView.swift
//  EZMacker
//
//  Created by 박유경 on 5/13/24.
//

import SwiftUI
struct NotificationAlarmView: View {
    @ObservedObject var notificationAlarmViewModel: NotificationAlarmViewModel
    @State private var toast: Toast?

    var body: some View {
        VStack {
            Text(CategoryType.notificationAlarm.title)
                .customText(fontSize: FontSizeType.small.size, isBold: false)
        }
        .navigationTitle(CategoryType.notificationAlarm.title)
        .padding()
    }
}
