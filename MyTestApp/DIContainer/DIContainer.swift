//
//  DIContainer.swift
//

import UIKit

final class DIContainer {
    private lazy var networkService: NetworkService = NetworkServiceImpl()
    
    func makeFeedViewController() -> FeedViewController {
        let vm = FeedViewModel(networkService: networkService)
        let vc = FeedViewController(viewModel: vm)
        return vc
    }
    
    func makeDetailsViewController(postId: Int) -> DetailsViewController {
        let vm = DetailsViewModel(postId: postId, networkService: networkService)
        let vc = DetailsViewController(viewModel: vm)
        return vc
    }
    
    func makeAppCoordinator(navigationController: UINavigationController) -> AppCoordinator {
        AppCoordinator(navigationController: navigationController, container: self)
    }
}
