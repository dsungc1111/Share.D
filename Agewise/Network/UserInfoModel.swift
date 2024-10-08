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
    let profileImage: String
    
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case email
        case nick
        case profileImage
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
struct CommentModel: Decodable {
    let comment_id: String
    let content: String
    let createdAt: String
    let creator: Creator
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
    let comments: [CommentModel]?
    
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
struct PayModel: Decodable {
    let buyer_id: String
    let post_id: String
    let merchant_uid: String
    let productName: String
    let price: Int
    let paidAt: String
}

struct MyPayModel: Decodable {
    let data: [PayModel]
}

struct Follow: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}
struct EditProfileModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String
    let followers: [Follow]
    let following: [Follow]
    let posts: [String]
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
struct EditPostQuery: Encodable {
    let nick: String
    let profileImage: String
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

struct CommentQuery: Encodable {
    let content: String
}

struct PaymentQuery: Encodable {
    let imp_uid: String
    let post_id: String
}
struct EditProfile: Encodable {
    let nick: String
    let profile: Data
}
