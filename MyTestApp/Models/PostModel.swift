//
//  PostModel.swift
//

import Foundation

struct PostModel: Decodable {
    let posts: [FeedPosts]
}

struct FeedPosts: Decodable {
    let postId: Int
    let timeshamp: Int
    let title: String
    let preview_text: String
    let likes_count: Int
}
