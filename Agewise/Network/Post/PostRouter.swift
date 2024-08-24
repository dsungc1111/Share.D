//
//  PostRouter.swift
//  Agewise
//
//  Created by 최대성 on 8/23/24.
//

import Foundation


import Foundation
import Alamofire

enum PostRouter {
    case postQuestion(query: PostQuery)
    case getPost(query: GetPostQuery) // 조회
    case detailPost(query: String)
    case editPost(query: PostQuery)
}

extension PostRouter: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL + "v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .postQuestion:
                .post
        case .getPost:
                .get
        case .detailPost:
                .get
        case .editPost:
                .put
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
        }
    }
    
    var header: [String : String] {
        switch self {
            
        case .getPost, .detailPost, .postQuestion, .editPost:
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
        case .getPost(let query):
            
            let param = [
                URLQueryItem(name: "next", value: query.next),
                URLQueryItem(name: "limit", value: query.limit),
                URLQueryItem(name: "product_id", value: query.product_id)
            ]
            return param
        default: return nil
        }
    }
    
    var body: Data? {
        return nil
    }
    
    
}
