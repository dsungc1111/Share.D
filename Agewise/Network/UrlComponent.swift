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
    case editProfile
    
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
        case .refresh:
                .get
        case .fetchProfile:
                .get
        case .editProfile:
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
        }
    }

    
    var header: [String : String] {
        switch self {
        case .join, .emailValidation, .login:
            return [
                APIKey.HTTPHeaderName.contentType.rawValue :  APIKey.HTTPHeaderName.json.rawValue,
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.DeveloperKey
            ]
        case .fetchProfile:
            return [
                APIKey.HTTPHeaderName.authorization.rawValue : UserDefaultManager.shared.accessToken,
                APIKey.HTTPHeaderName.contentType.rawValue :  APIKey.HTTPHeaderName.json.rawValue,
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.DeveloperKey
            ]
        case .editProfile:
            return [
                APIKey.HTTPHeaderName.authorization.rawValue : UserDefaultManager.shared.accessToken,
    //            HTTPHeaderName.contentType.rawValue : "multipart/form-data",
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.DeveloperKey
            ]
        case .refresh:
            return [
                APIKey.HTTPHeaderName.authorization.rawValue : UserDefaultManager.shared.accessToken,
                APIKey.HTTPHeaderName.refresh.rawValue : UserDefaultManager.shared.refreshToken,
                APIKey.HTTPHeaderName.contentType.rawValue :  APIKey.HTTPHeaderName.json.rawValue,
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.DeveloperKey
            ]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
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
            
       
            
        default: return nil
        }
    }
    
}
