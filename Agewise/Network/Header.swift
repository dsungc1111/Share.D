//
//  Header.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import Foundation
import Alamofire


enum Router {
    case login(query: LoginQuery)
    case fetchProfile
    case editProfile
    case refresh
}

extension Router: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL + "v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
                .post
        case .fetchProfile:
                .get
        case .editProfile:
                .put
        case .refresh:
                .get
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/users/login"
        case .fetchProfile, .editProfile:
            return baseURL + "/users/me/profile"
        case .refresh:
            return baseURL + "/auth/refresh"
        }
    }

    
    var header: [String : String] {
        switch self {
        case .login:
            return [
                APIKey.HTTPHeaderName.authorization.rawValue : UserDefaultManager.shared.accessToken,
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
        case .login(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
            
            
        default: return nil
        }
    }
    
}
