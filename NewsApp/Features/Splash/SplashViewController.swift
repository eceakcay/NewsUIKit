//
//  SplashViewController.swift
//  NewsApp
//
//  Created by Ece Akcay on 4.01.2026.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "newspaper")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "News"
        label.font = .boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        animateSplash()

    }
    
    private func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func navigateToMainTabBar() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            let tabBarController = MainTabBarController()
            
            guard let sceneDelegate = UIApplication.shared.connectedScenes
                .first?.delegate as? SceneDelegate else { return }
            
            sceneDelegate.window?.rootViewController = tabBarController
        }
    }
    
    private func animateSplash() {
        logoImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut) {
            self.logoImageView.transform = .identity
            self.titleLabel.alpha = 1
        } completion: { _ in
            self.navigateToMainTabBar()
        }
    }
    
}
