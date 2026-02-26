//
//  PostCell.swift
//

import UIKit

final class PostCell: UICollectionViewCell {
    static let reuseId = "postCell"
    
    private let titleLabel = UILabel()
    private let previewLabel = UILabel()
    private let likesLabel = UILabel()
    private let dateLabel = UILabel()
    private let button = UIButton(type: .system)
    
    private let rootStack = UIStackView()
    private let metaRow = UIStackView()
    
    var onTap: (() -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func setupUI() {
        contentView.backgroundColor = .systemBackground
        
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.numberOfLines = 1
        
        previewLabel.font = .systemFont(ofSize: 15, weight: .regular)
        previewLabel.textColor = .secondaryLabel
        previewLabel.numberOfLines = 2
        previewLabel.lineBreakMode = .byTruncatingTail
        
        likesLabel.font = .systemFont(ofSize: 13, weight: .regular)
        likesLabel.textColor = .secondaryLabel
        
        dateLabel.font = .systemFont(ofSize: 13, weight: .regular)
        dateLabel.textColor = .secondaryLabel
        dateLabel.textAlignment = .right
        
        button.setTitle("Expand", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
        button.backgroundColor = .systemGray2
        button.setTitleColor(.label, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        
        metaRow.axis = .horizontal
        metaRow.alignment = .center
        metaRow.distribution = .fill
        metaRow.spacing = 8
        
        metaRow.addArrangedSubview(likesLabel)
        metaRow.addArrangedSubview(UIView())
        metaRow.addArrangedSubview(dateLabel)
        
        rootStack.axis = .vertical
        rootStack.alignment = .fill
        rootStack.spacing = 10
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        
        rootStack.addArrangedSubview(titleLabel)
        rootStack.addArrangedSubview(previewLabel)
        rootStack.addArrangedSubview(metaRow)
        rootStack.addArrangedSubview(button)
        
        contentView.addSubview(rootStack)
        
        NSLayoutConstraint.activate([
            rootStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            rootStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rootStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rootStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
        ])
    }
    
    @objc private func onTapped() {
        onTap?()
    }
    
    func configure(with item: FeedPosts) {
        titleLabel.text = item.title
        previewLabel.text = item.preview_text
        likesLabel.text = "\(item.likes_count)"
        dateLabel.text = "21 days ago"
    }
    
}
