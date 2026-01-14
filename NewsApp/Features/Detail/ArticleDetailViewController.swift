//
//  ArticleDetailViewController.swift
//  NewsApp
//
//  Created by Ece Akcay on 6.01.2026.
//

import UIKit
import Kingfisher

final class ArticleDetailViewController: UIViewController {
    
    //MARK: - Properties
    private let article: Article
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let metaLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
               contentView.translatesAutoresizingMaskIntoConstraints = false

               view.addSubview(scrollView)
               scrollView.addSubview(contentView)

               contentView.addSubview(articleImageView)
               contentView.addSubview(titleLabel)
               contentView.addSubview(metaLabel)
               contentView.addSubview(contentLabel)

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
                   articleImageView.heightAnchor.constraint(equalToConstant: 220),

                   // Title
                   titleLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 16),
                   titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                   titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

                   // Meta
                   metaLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                   metaLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

                   // Content
                   contentLabel.topAnchor.constraint(equalTo: metaLabel.bottomAnchor, constant: 16),
                   contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                   contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                   contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
               ])    }
    
    // MARK: - Bind Data(Veri bAĞLAMA)
    private func bindData() {
        titleLabel.text = article.title
        contentLabel.text = article.content ?? article.description
        
        let source = article.source?.name ?? "Unknown Source"
        metaLabel.text = source
        
        if let imageUrl = URL(string: article.urlToImage ?? "") {
            articleImageView.kf.setImage(with: imageUrl)
        }
    }
    
    //paylaş butonu için action
    // MARK: - Share
        @objc private func shareTapped() {
            let items = [article.title ?? "", article.url ?? ""]
            let activityVC = UIActivityViewController(
                activityItems: items,
                applicationActivities: nil
            )
            present(activityVC, animated: true)
        }
}
