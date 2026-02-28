//
//  FeedViewModel.swift
//

import Foundation

final class FeedViewModel {
    
    var onPostUpdated: (() -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onError: ((Error) -> Void)?
    
    private var networkService: NetworkService = NetworkServiceImpl()
    private(set) var posts: [FeedPosts] = []
    
    init(networkService: NetworkService = NetworkServiceImpl()) {
        self.networkService = networkService
    }
    
    func loadFeed() {
        onLoadingChanged?(true)
        Task {
            do {
                let loaded = try await networkService.getFeedNews()
                await MainActor.run {
                    self.posts = loaded
                    self.onPostUpdated?()
                    self.onLoadingChanged?(false)
                }
            }
            catch {
                await MainActor.run {
                    print("❌", error)
                }
            }
        }
    }
    
    func numberOfItems() -> Int {
        posts.count
    }
    
    func post(at index: Int) -> FeedPosts {
        posts[index]
    }
}
