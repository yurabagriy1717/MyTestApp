//
//  FeedViewController.swift
//

import UIKit

final class FeedViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    var onPostSelected: ((Int) -> Void)?
    private let vm = FeedViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Feed"
        
        setupCollectionView()
        bindViewModel()
        vm.loadFeed()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(150)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(150)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 1
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
        
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
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
    
    private func bindViewModel() {
        vm.onPostUpdated = { [weak self] indexPath in
            guard let self else { return }

            if let indexPath {
                self.collectionView.reloadItems(at: [indexPath])
            } else {
                self.collectionView.reloadData()
            }
        }
        
        vm.onLoadingChanged = { isLoading in
            
        }
        
        vm.onError = { error in
            print("❌", error)
        }
    }
}

extension FeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PostCell.reuseId,
            for: indexPath
        ) as? PostCell else {
            return UICollectionViewCell()
        }
        
        let post = vm.post(at: indexPath.item)
        let contentWidth = collectionView.bounds.width - 32
        
        cell.configure(
            with: post,
            isExpanded: vm.isExpanded(postId: post.postId),
            contentWidth: contentWidth,
            onExpandTapped: { [weak self] in
                self?.vm.toggleExpanded(postId: post.postId)
            }
        )
        return cell
    }
}


extension FeedViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = vm.post(at: indexPath.item)
        onPostSelected?(post.postId)
    }
}
