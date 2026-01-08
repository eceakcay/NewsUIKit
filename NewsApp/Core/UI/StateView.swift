//
//  StateView.swift
//  NewsApp
//
//  Created by Ece Akcay on 8.01.2026.
//

import Foundation
import UIKit

final class StateView : UIView{
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Try Again", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var onAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(messageLabel)
        addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func configure(message: String, buttonTitle: String? = nil) {
        messageLabel.text = message
        actionButton.setTitle(buttonTitle ?? "Try Again", for: .normal)
        actionButton.isHidden = false
    }
    
    @objc private func buttonTapped() {
        onAction?()
    }
}
