//
//  AppCoordinator.swift
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
}


final class AppCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showFeed()
    }
    
    func showFeed() {
        let feedVC = FeedViewController()
        feedVC.onPostSelected = { [weak self] postId in
            self?.showDetails(postId: postId)
        }
        navigationController.setViewControllers([feedVC], animated: false)
    }
    
    func showDetails(postId: Int) {
        let detailsVC = DetailsViewController(postId: postId)
        navigationController.pushViewController(detailsVC, animated: true)
    }
    
    
}
