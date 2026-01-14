//
//  ArticleDetailViewController.swift
//  NewsApp
//
//  Created by Ece Akcay on 6.01.2026.
//

import UIKit
import Kingfisher

final class ArticleDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let article: Article
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.indicatorStyle = .default
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let metaLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // READ MORE BUTONU
    private let readMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Read Full Story", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemIndigo // Temanızın ana rengi
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        configureNavigationBar()
        bindData()
    }
    
    private func configureNavigationBar() {
        title = "News Detail"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareTapped)
        )
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Butonu buradaki listeye eklediğimizden emin oluyoruz
        [articleImageView, titleLabel, metaLabel, contentLabel, readMoreButton].forEach {
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Image
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            articleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            articleImageView.heightAnchor.constraint(equalToConstant: 250),

            // Title
            titleLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Meta
            metaLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            metaLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            // Content
            contentLabel.topAnchor.constraint(equalTo: metaLabel.bottomAnchor, constant: 20),
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Read More Button Constraints
            readMoreButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 30),
            readMoreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            readMoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            readMoreButton.heightAnchor.constraint(equalToConstant: 50),
            
            // KRİTİK: contentView'un sonunu butona bağlıyoruz ki sayfa butonun altına kadar kaysın
            readMoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        // Buton tıklama eylemi
        readMoreButton.addTarget(self, action: #selector(readMoreTapped), for: .touchUpInside)
    }
    
    // MARK: - Bind Data
    private func bindData() {
        titleLabel.text = article.title
        
        if let contentText = article.content ?? article.description {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            
            let attributedString = NSAttributedString(
                string: contentText,
                attributes: [.paragraphStyle: paragraphStyle]
            )
            contentLabel.attributedText = attributedString
        }
        
        let source = article.source?.name ?? "Unknown Source"
        metaLabel.text = "Source: \(source.uppercased())"
        
        if let imageUrlString = article.urlToImage, let imageUrl = URL(string: imageUrlString) {
            articleImageView.kf.setImage(
                with: imageUrl,
                options: [.transition(.fade(0.3))]
            )
        } else {
            articleImageView.image = UIImage(systemName: "photo")
            articleImageView.tintColor = .systemGray
        }
    }
    
    // MARK: - Actions
    
    @objc private func readMoreTapped() {
        guard let urlString = article.url, let url = URL(string: urlString) else { return }
        // Haberin orijinal web sayfasını açar
        UIApplication.shared.open(url)
    }
    
    @objc private func shareTapped() {
        let items: [Any] = [article.title ?? "", article.url ?? ""]
        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        present(activityVC, animated: true)
    }
}
