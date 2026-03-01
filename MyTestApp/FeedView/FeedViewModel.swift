//
//  FeedViewModel.swift
//

import Foundation

final class FeedViewModel {
    
    var onPostUpdated: (() -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onError: ((Error) -> Void)?
    private var expandedPostIds: Set<Int> = []

    
    private var networkService: NetworkService
    private(set) var posts: [FeedPosts] = []
    
    init(networkService: NetworkService) {
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
        onPostUpdated?()
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
    
    func makePostsItem() -> [PostItemModel] {
        posts.map { post in
            PostItemModel(posts: post, isExpanded: expandedPostIds.contains(post.postId))
        }
    }
}
