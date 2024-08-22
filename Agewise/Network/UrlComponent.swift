//
//  Header.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import Foundation
import Alamofire


enum Router {
    case join(query: JoinQuery)
    case emailValidation(query: EmailValidationQuery)
    case login(query: LoginQuery)
    case refresh
    case fetchProfile
    case withdraw
    case editProfile
    case postQuestion(query: PostQuery)
    case getPost(query: GetPostQuery)
    case detailPost(query: String)
    case editPost(query: String)
}

extension Router: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL + "v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .join:
                .post
        case .emailValidation:
                .post
        case .login:
                .post
        case .postQuestion:
                .post
            
            
        case .refresh:
                .get
        case .fetchProfile:
                .get
        case .withdraw:
                .get
        case .getPost:
                .get
        case .detailPost:
                .get
            
        case .editProfile:
                .put
        case .editPost:
                .put
        }
    }
    
    var path: String {
        switch self {
        case .join:
            return "/users/join"
        case .emailValidation:
            return "/validation/email"
        case .login:
            return "/users/login"
        case .refresh:
            return  "/auth/refresh"
        case .fetchProfile, .editProfile:
            return  "/users/me/profile"
        case .withdraw:
            return "/users/withdraw"
        case .postQuestion:
            return "/posts"
        case .getPost:
            return "/posts"
        case .detailPost(query: let query), .editPost(query: let query):
            return "/posts/\(query)"
            
        }
    }
    
    var header: [String : String] {
        switch self {
        case .join, .emailValidation, .login:
            return [
                APIKey.HTTPHeaderName.contentType.rawValue :  APIKey.HTTPHeaderName.json.rawValue,
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.DeveloperKey
            ]
        case .editProfile, .withdraw, .getPost, .detailPost, .fetchProfile, .postQuestion, .editPost:
            return [
                APIKey.HTTPHeaderName.authorization.rawValue : UserDefaultManager.shared.accessToken,
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.DeveloperKey,
                APIKey.HTTPHeaderName.contentType.rawValue :  APIKey.HTTPHeaderName.json.rawValue,
            ]
        case .refresh:
            return [
                APIKey.HTTPHeaderName.authorization.rawValue : UserDefaultManager.shared.accessToken,
                APIKey.HTTPHeaderName.refresh.rawValue : UserDefaultManager.shared.refreshToken,
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
        
        switch self {
            
        case .join(query: let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
            
        case .emailValidation(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
            
        case .login(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
            
        case .postQuestion(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
            
        default: return nil
        }
    }
    
}


