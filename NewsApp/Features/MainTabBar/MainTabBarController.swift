//
//  MainTabBarController.swift
//  NewsApp
//
//  Created by Ece Akcay on 13.01.2026.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarAppearance()
        setupTabs()
    }
    
    private func configureTabBarAppearance() {
        // Tab Bar'ın genel rengini (ikonlar ve yazılar) mor yapıyoruz
        tabBar.tintColor = .systemIndigo
        
        // Seçilmeyen ikonların rengini ayarlayabilirsiniz (opsiyonel)
        tabBar.unselectedItemTintColor = .secondaryLabel
        
        // iOS 15+ için modern görünüm ayarları
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        
        // Tab Bar arka planını hafif şeffaf yaparak modern bir hava katalım
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func setupTabs() {
        
        // 1. News Tab
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(
            title: "News",
            image: UIImage(systemName: "newspaper"),
            selectedImage: UIImage(systemName: "newspaper.fill")
        )
        
        // 2. Settings Tab
        // Not: SettingsViewController'ı style ile başlatmak istersen (insetGrouped için):
        let settingsVC = SettingsViewController(style: .insetGrouped)
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        
        // View Controller'ları diziye ekliyoruz
        viewControllers = [homeNav, settingsNav]
    }
}
