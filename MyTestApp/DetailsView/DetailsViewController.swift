//
//  DetailsViewController.swift
//

import UIKit

final class DetailsViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var post: DetailPosts?
    private var postId: Int
    private let networkService: NetworkService = NetworkServiceImpl()
    
    init(postId: Int) {
        self.postId = postId
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
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(DetailPostCell.self, forCellWithReuseIdentifier: DetailPostCell.reuseId)

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
    
    private func loadDetails() {
        Task {
            do {
                let loaded = try await networkService.getDetailNews(id: postId)
                await MainActor.run {
                    self.post = loaded
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


extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailPostCell.reuseId, for: indexPath) as? DetailPostCell else {
            return UICollectionViewCell()
        }
        
        guard let post = post else { return UICollectionViewCell() }
        cell.configure(with: post)
        return cell
    }
    
    
}


extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width - 32, height: 500)
    }
}

