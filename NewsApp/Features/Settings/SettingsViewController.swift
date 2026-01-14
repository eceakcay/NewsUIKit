//
//  SettingsViewController.swift
//  NewsApp
//
//  Created by Ece Akcay
//

import UIKit
import UserNotifications

final class SettingsViewController: UITableViewController {

    // MARK: - Properties
    private let notificationSwitch = UISwitch()

    private let notificationKey = "notifications_enabled"

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupSwitch()
    }

    // MARK: - Switch Setup
    private func setupSwitch() {
        notificationSwitch.addTarget(
            self,
            action: #selector(notificationSwitchChanged),
            for: .valueChanged
        )

        // Daha önce kaydedilmiş durumu yükle
        notificationSwitch.isOn =
        UserDefaults.standard.bool(forKey: notificationKey)
    }

    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "Bildirimler"
        cell.accessoryView = notificationSwitch
        cell.selectionStyle = .none
        return cell
    }

    // MARK: - Switch Action
    @objc private func notificationSwitchChanged() {
        let isEnabled = notificationSwitch.isOn
        UserDefaults.standard.set(isEnabled, forKey: notificationKey)

        if isEnabled {
            requestNotificationPermission()
        } else {
            NotificationManager.shared.cancelNotification()
        }
    }

    // MARK: - Notification Permission
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    // ✅ İzin verildiyse bildirimi planla
                    NotificationManager.shared.scheduleDailyNotification()
                } else {
                    // ❌ İzin verilmediyse switch’i geri kapat
                    self.notificationSwitch.isOn = false
                    UserDefaults.standard.set(false, forKey: self.notificationKey)
                }
            }
        }
    }
}
