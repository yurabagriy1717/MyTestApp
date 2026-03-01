//
//  DetailsViewController.swift
//

import UIKit

final class DetailsViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let vm: DetailsViewModel
    
    init(postId: Int) {
        self.vm = DetailsViewModel(postId: postId)
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
        bindViewModel()
        vm.loadDetails()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(DetailPostCell.self, forCellWithReuseIdentifier: DetailPostCell.reuseId)
        
        collectionView.dataSource = self
//        collectionView.delegate = self
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0) ,
            heightDimension: .estimated(150)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(150)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 1
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func bindViewModel() {
        vm.onPostUpdated = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        vm.onLoadingChanged = { isLoading in
            
        }
        
        vm.onError = { error in
            print("❌", error)
        }
    }
}


extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.hasPost() ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailPostCell.reuseId, for: indexPath) as? DetailPostCell else {
            return UICollectionViewCell()
        }
        
        guard let post = vm.posts else { return UICollectionViewCell() }
        cell.configure(with: post)
        return cell
    }
    
    
}
//
//extension DetailsViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: collectionView.bounds.width - 32, height: 1000)
//    }
//}

