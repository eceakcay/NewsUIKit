//
//  SettingsViewController.swift
//  NewsApp
//
//  Created by Ece Akcay.
//

import UIKit
import UserNotifications

// MARK: - Models
struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let isOn: Bool?
    let action: (() -> Void)?
}

struct SettingsSection {
    let title: String
    let options: [SettingsOption]
}

final class SettingsViewController: UITableViewController {

    // MARK: - Properties
    private var sections = [SettingsSection]()
    private let notificationKey = "notifications_enabled"

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureModels()
    }

    private func setupUI() {
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemGroupedBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func configureModels() {
        // Section 1: Appearance
        sections.append(SettingsSection(title: "Appearance", options: [
            SettingsOption(
                title: "Dark Mode",
                icon: UIImage(systemName: "moon.fill"),
                iconBackgroundColor: .systemPurple,
                isOn: traitCollection.userInterfaceStyle == .dark,
                action: nil
            )
        ]))
        
        // Section 2: Notifications
        sections.append(SettingsSection(title: "Notifications", options: [
            SettingsOption(
                title: "Push Notifications",
                icon: UIImage(systemName: "bell.badge.fill"),
                iconBackgroundColor: .systemRed,
                isOn: UserDefaults.standard.bool(forKey: notificationKey),
                action: nil
            )
        ]))

        // Section 3: App Info
        sections.append(SettingsSection(title: "App Info", options: [
            SettingsOption(
                title: "Privacy Policy",
                icon: UIImage(systemName: "hand.raised.fill"),
                iconBackgroundColor: .systemBlue,
                isOn: nil,
                action: { [weak self] in self?.openPrivacyPolicy() }
            ),
            SettingsOption(
                title: "App Version",
                icon: UIImage(systemName: "info.circle.fill"),
                iconBackgroundColor: .systemGray,
                isOn: nil,
                action: nil
            )
        ]))
    }

    // MARK: - TableView DataSource & Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = sections[indexPath.section].options[indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.textLabel?.text = option.title
        
        if let icon = option.icon {
            cell.imageView?.image = icon
            cell.imageView?.tintColor = option.iconBackgroundColor
        }

        if let isOn = option.isOn {
            let mySwitch = UISwitch()
            mySwitch.isOn = isOn
            
            // KRİTİK DÜZELTME: Hangi switch hangi fonksiyonu çalıştıracak?
            if option.title == "Dark Mode" {
                mySwitch.addTarget(self, action: #selector(appearanceSwitchChanged(_:)), for: .valueChanged)
            } else {
                mySwitch.addTarget(self, action: #selector(notificationSwitchChanged(_:)), for: .valueChanged)
            }
            
            cell.accessoryView = mySwitch
            cell.selectionStyle = .none
        } else {
            cell.accessoryType = option.title == "App Version" ? .none : .disclosureIndicator
            if option.title == "App Version" {
                cell.detailTextLabel?.text = "1.0.0"
            }
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = sections[indexPath.section].options[indexPath.row]
        option.action?()
    }

    // MARK: - Dark Mode Logic
    @objc private func appearanceSwitchChanged(_ sender: UISwitch) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            
            // Yumuşak geçiş efekti
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
                window.overrideUserInterfaceStyle = sender.isOn ? .dark : .light
            }
        }
    }

    // MARK: - Notification Logic
    @objc private func notificationSwitchChanged(_ sender: UISwitch) {
        let isEnabled = sender.isOn
        UserDefaults.standard.set(isEnabled, forKey: notificationKey)

        if isEnabled {
            requestNotificationPermission(sender: sender)
        } else {
            // NotificationManager.shared.cancelNotification() // Manager sınıfın varsa aktifleştir
            print("Notifications disabled")
        }
    }

    private func requestNotificationPermission(sender: UISwitch) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    // NotificationManager.shared.scheduleDailyNotification() // Manager sınıfın varsa aktifleştir
                    print("Permission granted")
                } else {
                    sender.setOn(false, animated: true)
                    UserDefaults.standard.set(false, forKey: self.notificationKey)
                }
            }
        }
    }

    private func openPrivacyPolicy() {
        print("Privacy Policy Tapped")
    }
}
