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
        setupTabs()

    }
    
    private func setupTabs() {
        
        //News
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(
            title: "News",
            image: UIImage(systemName: "newspaper"),
            selectedImage: UIImage(systemName: "newspaper.fill")
        )
        
        //Settings
        let settingsVC = SettingsViewController()
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        
        viewControllers = [homeNav, settingsNav]
        
    }
}

//Splash → root // Sonra → TabBar //Her tab → NavigationController
