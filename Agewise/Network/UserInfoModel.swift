//
//  LoginModel.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import Foundation

//MARK: - 받아오는 모델
struct JoinModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
}
struct EmailValidationModel: Decodable {
    let message: String
}
struct LoginModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let accessToken: String
    let refreshToken: String
}
struct RefreshModel: Decodable {
    let accessToken: String
}
struct ProfileModel: Decodable {
    let id: String
    let email: String
    let nick: String
    
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case email
        case nick
    }
}

struct Creator: Decodable {
    let userId: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
}
struct PostModelToWrite: Decodable {
    let postID: String
    let productId: String
    let title: String
    let price: Int?
    let content: String
    let content1: String
    let content2: String
    let createdAt: String
    let creator: Creator
    let files: [String]?
    let likes: [String]?
    let likes2: [String]?
    let hashTags: [String]?
    let comments: [String]?
    
    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case productId = "product_id"
        case price
        case title
        case content
        case content1
        case content2
        case createdAt
        case creator
        case files
        case likes
        case likes2
        case hashTags
        case comments
    }
}
struct PostModelToView: Decodable {
    let data: [PostModelToWrite]
    let next_cursor: String?
}

struct LikeModel: Decodable {
    let like_status: Bool
}




//MARK: - 요청 쿼리
struct LoginQuery: Encodable {
    let email: String
    let password: String
}
struct JoinQuery: Encodable {
    let email: String
    let password: String
    let nick: String
}
struct EmailValidationQuery: Encodable {
    let email: String
}
struct PostQuery: Encodable {
    let title: String
    let price: Int
    let content: String
    let content1: String
    let content2: String
    let product_id: String
    let files: [String]
}
struct GetPostQuery: Encodable {
    let next: String
    let limit: String
    var product_id: String
}
struct LikeQuery: Encodable {
    let like_status: Bool
}
struct LikePostQuery: Encodable {
    let next: String
    let limit: String
}
