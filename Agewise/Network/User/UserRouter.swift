//
//  UserRouter.swift
//  Agewise
//
//  Created by 최대성 on 8/23/24.
//

import Foundation
import Alamofire

enum UserRouter {
    case join(query: JoinQuery)
    case emailValidation(query: EmailValidationQuery)
    case login(query: LoginQuery)
    case withdraw
    case edit(query: EditProfile)
}

extension UserRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL + "v1"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .join:
                .post
        case .emailValidation:
                .post
        case .login:
                .post
        case .withdraw:
                .get
        case .edit:
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
        case .withdraw:
            return "/users/withdraw"
        case .edit:
            return "/users/me/profile"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .join, .emailValidation, .login:
            return [
                APIKey.HTTPHeaderName.contentType.rawValue :  APIKey.HTTPHeaderName.json.rawValue,
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.DeveloperKey
            ]
        case .withdraw:
            return [
                APIKey.HTTPHeaderName.authorization.rawValue : UserDefaultManager.shared.accessToken,
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.DeveloperKey,
                APIKey.HTTPHeaderName.contentType.rawValue :  APIKey.HTTPHeaderName.json.rawValue,
            ]
        case .edit:
            return [
                APIKey.HTTPHeaderName.authorization.rawValue : UserDefaultManager.shared.accessToken,
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.DeveloperKey,
                APIKey.HTTPHeaderName.contentType.rawValue :  APIKey.HTTPHeaderName.mutipart.rawValue,
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
      
      var multipartFormData: MultipartFormData {
          let formData = MultipartFormData()
          switch self {
          case .edit(let query):
              formData.append(query.nick.data(using: .utf8)!, withName: "nick")
              formData.append(query.profile, withName: "profile", fileName: "profile.png", mimeType: "image/png")
          default:
              break
          }
          return formData
      }
    
}
