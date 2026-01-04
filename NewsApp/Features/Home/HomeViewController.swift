//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Ece Akcay on 4.01.2026.
//

import UIKit

final class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
    }

    private func configureNavigationBar() {
        title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

