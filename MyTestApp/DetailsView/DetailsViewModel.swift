//
//  DetailsViewModel.swift
//

import Foundation

final class DetailsViewModel {
    
    var onPostUpdated: (() -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onError: ((Error) -> Void)?
    
    private let networkService: NetworkService
    private(set) var posts: DetailPosts?
    private let postId: Int
    
    init(postId: Int,networkService: NetworkService) {
        self.networkService = networkService
        self.postId = postId
    }
    
    func loadDetails() {
        onLoadingChanged?(true)
        Task {
            do {
                let loaded = try await networkService.getDetailNews(id: postId )
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
    
    func hasPost() -> Bool {
           posts != nil
       }
    
}
