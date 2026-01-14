//
//  SceneDelegate.swift
//  NewsApp
//
//  Created by Ece Akcay on 4.01.2026.
//

///Uygulama açıldığında, ilk gösterilecek ekranı SplashViewController olarak ayarlıyor.
import UIKit
import UserNotifications


class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
        
        self.window = window
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }

    
    private func openNewsTab() {
        
        guard let window = self.window else { return }
        
        // Root TabBar ise
        if let tabBarController = window.rootViewController as? MainTabBarController {
            tabBarController.selectedIndex = 0
            return
        }
        
        // Splash açıksa → önce TabBar’a geç
        let  tabBarController = MainTabBarController()
        tabBarController.selectedIndex = 0
        window.rootViewController = tabBarController

    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {

        let isNotificationEnabled =
        UserDefaults.standard.bool(forKey: "notifications_enabled")

        if isNotificationEnabled {
            NotificationManager.shared.scheduleDailyNotification()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

