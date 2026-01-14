//
//  NotificationManager.swift
//  NewsApp
//
//  Created by Ece Akcay on 14.01.2026.
//

import Foundation
import UserNotifications

final class NotificationManager {

    static let shared = NotificationManager()

    private init() {}

    func scheduleDailyNotification() {

        let content = UNMutableNotificationContent()
        content.title = "News"
        content.body = "Don't miss the latest news 📰"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 5,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "daily_news_notification",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    func cancelNotification() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: ["daily_news_notification"]
            )
    }
}
