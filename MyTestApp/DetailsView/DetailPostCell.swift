//
//  DetailPostCell.swift
//

import UIKit

final class DetailPostCell: UICollectionViewCell {
    static let reuseId = "detailPostCell"
    
    private let postImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let likesLabel = UILabel()
    private let dateLabel = UILabel()
    
    private let textStack = UIStackView()
    private let metaRow = UIStackView()
    private let textContainer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        
        // Image
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.backgroundColor = .systemGray5
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        
        // Labels
        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        titleLabel.numberOfLines = 0
        
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        
        likesLabel.font = .systemFont(ofSize: 14)
        likesLabel.textColor = .secondaryLabel
        
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .secondaryLabel
        dateLabel.textAlignment = .right
        
        // Meta row
        metaRow.axis = .horizontal
        metaRow.alignment = .center
        metaRow.spacing = 8
        metaRow.addArrangedSubview(likesLabel)
        metaRow.addArrangedSubview(UIView())
        metaRow.addArrangedSubview(dateLabel)
        
        // Text stack
        textStack.axis = .vertical
        textStack.alignment = .fill
        textStack.spacing = 10
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(descriptionLabel)
        textStack.addArrangedSubview(metaRow)
        
        // Text container (to keep 16pt padding only for text, not for image)
        textContainer.translatesAutoresizingMaskIntoConstraints = false
        textContainer.addSubview(textStack)
        
        // Add views
        contentView.addSubview(postImageView)
        contentView.addSubview(textContainer)
        
        NSLayoutConstraint.activate([
            // Image full width
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalToConstant: 320),
            
            // Text container under image
            textContainer.topAnchor.constraint(equalTo: postImageView.bottomAnchor),
            textContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Inner padding 16
            textStack.topAnchor.constraint(equalTo: textContainer.topAnchor, constant: 16),
            textStack.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor, constant: -16),
            textStack.bottomAnchor.constraint(equalTo: textContainer.bottomAnchor, constant: -16),
        ])
    }
    
    
    func configure(with item: DetailPosts) {
        titleLabel.text = item.title
        descriptionLabel.text = item.text
        likesLabel.text = "❤️ \(item.likes_count)"
        dateLabel.text = "21 days ago"
        
        postImageView.image = nil
        Task {
            if let image = try? await loadImage(from: item.postImage) {
                await MainActor.run {
                    self.postImageView.image = image
                }
            }
        }
    }
    
    func loadImage(from urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        let(data,response) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }
}
