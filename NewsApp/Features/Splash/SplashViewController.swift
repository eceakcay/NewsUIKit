//
//  SplashViewController.swift
//  NewsApp
//
//  Created by Ece Akcay on 4.01.2026.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - UI Components
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "newspaper")
        // Temaya uygun olarak Indigo rengini veriyoruz
        imageView.tintColor = .systemIndigo
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "News"
        label.font = .systemFont(ofSize: 32, weight: .black) // Biraz daha kalın ve büyük font
        label.textColor = .label
        label.textAlignment = .center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        animateSplash()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Navigation
    private func navigateToMainTabBar() {
        // Kullanıcıya animasyonu görmesi için kısa bir bekleme süresi
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            let tabBarController = MainTabBarController()
            
            guard let sceneDelegate = UIApplication.shared.connectedScenes
                .first?.delegate as? SceneDelegate else { return }
            
            // Geçişin çok sert olmaması için küçük bir fade efekti ekleyelim
            UIView.transition(with: sceneDelegate.window!,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                sceneDelegate.window?.rootViewController = tabBarController
            }, completion: nil)
        }
    }
    
    // MARK: - Animation
    private func animateSplash() {
        // Başlangıçta logoyu küçültelim
        logoImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

        // Spring animasyonu ile logonun "zıplayarak" gelmesini sağlayalım (Daha modern bir his)
        UIView.animate(withDuration: 1.0,
                       delay: 0.2,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.7,
                       options: .curveEaseOut) {
            self.logoImageView.transform = .identity
            self.titleLabel.alpha = 1
        } completion: { _ in
            self.navigateToMainTabBar()
        }
    }
}
