//
//  FeedViewController.swift
//

import UIKit

final class FeedViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    var onPostSelected: ((Int) -> Void)?
    private let vm: FeedViewModel
    private var dataSource: UICollectionViewDiffableDataSource<FeedSection, PostItemModel>!
    
    init(viewModel: FeedViewModel) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Feed"
        
        setupCollectionView()
        setupDataSource()
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
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            [weak self] collectionView, IndexPath, item in
            guard let self,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.reuseId, for: IndexPath) as? PostCell else {
                      return UICollectionViewCell()
                  }
            let contentWidth = collectionView.bounds.width - 32
            cell.configure(
                with: item.posts,
                isExpanded: item.isExpanded,
                contentWidth: contentWidth,
                onExpandTapped: { [weak self] in
                    self?.vm.toggleExpanded(postId: item.posts.postId)
                }
            )
            return cell
        }
    }
    
    private func applySnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<FeedSection, PostItemModel>()
        snapShot.appendSections([.main])
        snapShot.appendItems(vm.makePostsItem())
        dataSource.apply(snapShot, animatingDifferences: true)
    }
    
    private func bindViewModel() {
        vm.onPostUpdated = { [weak self]  in
            self?.applySnapShot()
        }
        
        vm.onLoadingChanged = { isLoading in
            
        }
        
        vm.onError = { error in
            print("❌", error)
        }
    }
}


extension FeedViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        onPostSelected?(item.posts.postId)
    }
}


enum FeedSection {
    case main
}
