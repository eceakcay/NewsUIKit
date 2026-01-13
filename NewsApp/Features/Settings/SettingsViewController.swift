//
//  SettingsViewController.swift
//  NewsApp
//
//  Created by Ece Akcay on 8.01.2026.
//

import UIKit
import UserNotifications


final class SettingsViewController: UITableViewController {
    
    enum SettingItem: Int, CaseIterable {
        case notifications
        
        var title: String {
            switch self {
            case .notifications:
                return "Notifications"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - TableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SettingItem.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        let item = SettingItem(rawValue: indexPath.row)
        cell.textLabel?.text = item?.title
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    //MARK: - Tableview Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == SettingItem.notifications.rawValue {
            requestNotificationPermission()
        }
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                let message = granted
                ? "Notifications allowed ✅"
                : "Notifications denied ❌"
                
                let alert = UIAlertController(
                    title: "Notifications",
                    message: message,
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}


