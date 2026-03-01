//
//  FeedViewModel.swift
//

import Foundation

final class FeedViewModel {
    
    var onPostUpdated: ((IndexPath?) -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onError: ((Error) -> Void)?
    private var expandedPostIds: Set<Int> = []

    
    private var networkService: NetworkService = NetworkServiceImpl()
    private(set) var posts: [FeedPosts] = []
    
    init(networkService: NetworkService = NetworkServiceImpl()) {
        self.networkService = networkService
    }
    
    func isExpanded(postId: Int) -> Bool {
        expandedPostIds.contains(postId)
    }
    
    func toggleExpanded(postId: Int) {
        if expandedPostIds.contains(postId) {
            expandedPostIds.remove(postId)
        } else {
            expandedPostIds.insert(postId)
        }
        if let index = posts.firstIndex(where: { $0.postId == postId }) {
            onPostUpdated?(IndexPath(item: index, section: 0))
        }
    }
    
    func loadFeed() {
        onLoadingChanged?(true)
        Task {
            do {
                let loaded = try await networkService.getFeedNews()
                await MainActor.run {
                    self.posts = loaded
                    self.onPostUpdated?(nil)
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
