//
//  FeedViewController.swift
//

import UIKit

final class FeedViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var posts: [FeedPosts] = []
    private let networkService: NetworkService = NetworkServiceImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Feed"
        
        setupCollectionView()
        loadFeed()
    }
    
    private func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.reuseId)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func loadFeed() {
        Task {
            do {
                let loaded = try await networkService.getFeedNews()
                await MainActor.run {
                    self.posts = loaded
                    self.collectionView.reloadData()
                }
            }
            catch {
                await MainActor.run {
                    print("❌", error)
                    // можна показати алерт
                }
            }
        }
    }
}


extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.reuseId, for: indexPath) as? PostCell else {
            return UICollectionViewCell()
        }
        
        let post = posts[indexPath.item]
        cell.configure(with: post)
        return cell
    }
    
    
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width - 32, height: 180)
    }
}
