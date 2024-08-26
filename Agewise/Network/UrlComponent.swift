//
//  Header.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import Foundation
import Alamofire


enum Router {
   
    case editProfile
    case postQuestion(query: PostQuery)
    case getPost(query: GetPostQuery)
    case detailPost(query: String)
    case editPost(query: String)
    case viewPost(query: GetPostQuery)
}

extension Router: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL + "v1"
    }
    
    var method: HTTPMethod {
        switch self {
        
        case .postQuestion:
                .post
            
       
        case .getPost, .viewPost:
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
        
        case .editProfile:
            return  "/users/me/profile"
        case .postQuestion:
            return "/posts"
        case .getPost:
            return "/posts"
        case .detailPost(query: let query), .editPost(query: let query):
            return "/posts/\(query)"
            
        case .viewPost(query: let query):
            return "/posts/users/\(UserDefaultManager.shared.userId)"
        }
    }
    
    var header: [String : String] {
        switch self {
        
        case .editProfile, .getPost, .detailPost, .postQuestion, .editPost, .viewPost:
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
        
        switch self {
            
        case .postQuestion(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
            
        default: return nil
        }
    }
    
}


