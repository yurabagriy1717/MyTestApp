//
//  AppCoordinator.swift
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
}


final class AppCoordinator: Coordinator {
    private let container: DIContainer
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, container: DIContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        showFeed()
    }
    
    func showFeed() {
        let feedVC = container.makeFeedViewController()
        feedVC.onPostSelected = { [weak self] postId in
            self?.showDetails(postId: postId)
        }
        navigationController.setViewControllers([feedVC], animated: false)
    }
    
    func showDetails(postId: Int) {
        let detailsVC = container.makeDetailsViewController(postId: postId)
        navigationController.pushViewController(detailsVC, animated: true)
    }
    
    
}
