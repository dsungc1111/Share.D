//
//  PostRouter.swift
//  Agewise
//
//  Created by 최대성 on 8/23/24.
//


import Foundation
import Alamofire


enum PostRouter {
    case postQuestion(query: PostQuery)
    case getPost(query: GetPostQuery) // 조회
    case detailPost(query: String)
    case editPost(query: PostQuery)
    case delete(query: String)
    case viewPost(query: GetPostQuery)
    case likePost(String, LikeQuery)
    case viewLikePost(query: LikePostQuery)
    case uploadComment(String, CommentQuery)
    case deleteComment(String, String)
    case payment(query: PaymentQuery)
    case getBuyerInfo
}

extension PostRouter: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL + "v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .postQuestion, .likePost, .uploadComment, .payment:
                .post
        case .getPost, .viewLikePost, .getBuyerInfo:
                .get
        case .detailPost:
                .get
        case .editPost:
                .put
        case .delete, .deleteComment:
                .delete
        case .viewPost:
                .get
        }
    }
    
    var path: String {
        switch self {
        case .postQuestion:
            return "/posts"
        case .getPost:
            return "/posts"
        case .detailPost(query: let query):
            return "/posts/\(query)"
        case .editPost:
            return "/posts/\(UserDefaultManager.shared.userId)"
        case .delete(query: let query) :
            return "/posts/\(query)"
        case .viewPost:
            return "/posts/users/\(UserDefaultManager.shared.userId)"
        case .likePost(let post_id, _):
            return "/posts/\(post_id)/like"
        case .viewLikePost:
            return "/posts/likes/me"
        case .uploadComment(let postId, _):
            return "/posts/\(postId)/comments"
        case .deleteComment(let postId, let commentId):
            return "/posts/\(postId)/comments/\(commentId)"
        case .payment:
            return "/payments/validation"
        case .getBuyerInfo:
            return "/payments/me"
        }
    }
    
    var header: [String : String] {
        switch self {
            
        case .getPost, .detailPost, .postQuestion, .editPost, .delete, .viewPost, .likePost, .viewLikePost, .uploadComment, .deleteComment, .payment, .getBuyerInfo:
            
            return [
                APIKey.HTTPHeaderName.authorization.rawValue : UserDefaultManager.shared.accessToken,
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.DeveloperKey,
                APIKey.HTTPHeaderName.contentType.rawValue :  APIKey.HTTPHeaderName.json.rawValue,
            ]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getPost(let query), .viewPost(let query):
            
            let param = [
                URLQueryItem(name: "next", value: query.next),
                URLQueryItem(name: "limit", value: query.limit),
                URLQueryItem(name: "product_id", value: query.product_id)
            ]
            return param
            
        case .viewLikePost(let query):
            
            let param = [
                URLQueryItem(name: "next", value: query.next),
                URLQueryItem(name: "limit", value: query.limit)
            ]
            return param
            
        default: return nil
        }
    }
    
    var body: Data? {
        
        switch self {
        case .postQuestion(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
            
        case .likePost(_, let like):
//            let param: [String : Bool] = ["like_status" : like.like_status]
            let encoder = JSONEncoder()
            return try? encoder.encode(like)
            
        case .uploadComment(_, let comment):
            let encoder = JSONEncoder()
            return try? encoder.encode(comment)
            
        case .payment(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
            
        default: return nil
            
        }
        
    }
    
    
}

