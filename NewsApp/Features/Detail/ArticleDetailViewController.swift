//
//  ArticleDetailViewController.swift
//  NewsApp
//
//  Created by Ece Akcay on 6.01.2026.
//

import UIKit

final class ArticleDetailViewController: UIViewController {
    
    //MARK: - Properties
    private let article: Article
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //ihtiyacı olan veriyi init’te alıyor
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        configureNavigationBar()
        bindData()

    }
    
    private func configureNavigationBar() {
        title = "News Detail"
        //paylaş butonu
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareTapped)
        )
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
               ])
    }
    
    //verileri bağlama
    private func bindData() {
        titleLabel.text = article.title
        subtitleLabel.text = article.description
    }
    
    //paylaş butonu için action
    @objc private func shareTapped() {
        let activityVC = UIActivityViewController(
            activityItems: [article.title],
            applicationActivities: nil
        )
        present(activityVC, animated: true)
    }
}
