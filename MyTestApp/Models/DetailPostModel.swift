//
//  DetailPostModel.swift
//

import Foundation

struct DetailPostModel: Decodable {
    let posts: [DetailPosts]
}

struct DetailPosts: Decodable {
    let postId: Int
    let timeshamp: Int
    let title: String
    let text: String
    let postImage: String
    let likes_count: Int
}
