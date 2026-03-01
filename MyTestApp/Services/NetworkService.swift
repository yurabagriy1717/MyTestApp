//
//  NetworkService.swift
//

import Foundation

protocol NetworkService {
    func getFeedNews() async throws -> [FeedPosts]
    func getDetailNews(id: Int) async throws -> DetailPosts
}

final class NetworkServiceImpl: NetworkService {
    
    func getFeedNews() async throws -> [FeedPosts] {
        guard let url = URL(string: "https://raw.githubusercontent.com/anton-natife/jsons/master/api/main.json") else {
            throw URLError(.badURL)
        }
        
        do {
            let(data,response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            let model = try JSONDecoder().decode(PostModel.self, from: data)
            return model.posts
        } catch {
            print("❌ Network error:", error)
            throw error
        }
    }
    
    func getDetailNews(id: Int) async throws -> DetailPosts {
        guard let url = URL(string: "https://raw.githubusercontent.com/anton-natife/jsons/master/api/posts/\(id).json") else {
            throw URLError(.badURL)
        }
        
        do {
            let (data,response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            let model = try JSONDecoder().decode(DetailPostModel.self, from: data)
            return model.post
        } catch {
            print("❌ Network error:", error)
            throw error
        }
        
    }
    
}
