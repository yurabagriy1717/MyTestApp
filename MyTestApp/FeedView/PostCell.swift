//
// PostCell.swift
//

import UIKit

final class PostCell: UICollectionViewCell {
    static let reuseId = "postCell"
    
    private let titleLabel = UILabel()
    private let previewLabel = UILabel()
    private let likesLabel = UILabel()
    private let dateLabel = UILabel()
    private let button = UIButton(type: .system)
    private let buttonContainer = UIView()
    
    private let rootStack = UIStackView()
    private let metaRow = UIStackView()
    
    var onExpandTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        previewLabel.text = nil
        likesLabel.text = nil
        dateLabel.text = nil
        previewLabel.numberOfLines = 2
        buttonContainer.isHidden = true
        onExpandTapped = nil
    }
    
    private func setupUI() {
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
        buttonContainer.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
        rootStack.addArrangedSubview(buttonContainer)
        contentView.addSubview(rootStack)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor),
            button.topAnchor.constraint(equalTo: buttonContainer.topAnchor),
            button.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor),
            
            rootStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            rootStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rootStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rootStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14)
        ])
    }
    
    @objc private func onTapped() {
        onExpandTapped?()
    }
    
    private func isTextLongerThanTwoLines(text: String, font: UIFont, width: CGFloat) -> Bool {
        let label = UILabel()
        label.font = font
        label.numberOfLines = 0
        label.text = text
        let fullSize = label.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        
        label.numberOfLines = 2
        let twoLineSize = label.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        
        return fullSize.height > twoLineSize.height + 1
    }
    
    func configure(with item: FeedPosts, isExpanded: Bool, contentWidth: CGFloat, onExpandTapped: @escaping () -> Void) {
        titleLabel.text = item.title
        previewLabel.text = item.preview_text
        likesLabel.text = "❤️ \(item.likes_count)"
        dateLabel.text = item.timeshamp.timeAgoString
        
        self.onExpandTapped = onExpandTapped
        
        let width = contentWidth > 0 ? contentWidth : (contentView.bounds.width - 32)
        let isLong = isTextLongerThanTwoLines(text: item.preview_text, font: previewLabel.font ?? .systemFont(ofSize: 15), width: width)
        
        if isLong {
            buttonContainer.isHidden = false
            previewLabel.numberOfLines = isExpanded ? 0 : 2
            previewLabel.lineBreakMode = .byTruncatingTail
            button.setTitle(isExpanded ? "Collapse" : "Expand", for: .normal)
        } else {
            buttonContainer.isHidden = true
            previewLabel.numberOfLines = 0
        }
    }
}
