//
//  NetworkManager.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import Foundation
import Alamofire

struct LoginQuery: Encodable {
    let email: String
    let password: String
}
struct JoinQuery: Encodable {
    let email: String
    let password: String
    let nick: String
}

enum NetworkError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}


final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    
    static func join(email: String, password: String, nickname: String, completionHandler: @escaping (Result<JoinModel, NetworkError>) -> Void) {
        do {
            let query = JoinQuery(email: email, password: password, nick: nickname)
            let request = try Router.join(query: query).asURLRequest()
            
            AF.request(request).responseDecodable(of: JoinModel.self) { response in
                switch response.result {
                case .success(let value):
                    completionHandler(.success(value))
                case .failure( _):
                    completionHandler(.failure(NetworkError.invalidURL))
                }
            }
            
        } catch {
            print("터져버림")
        }
        
    }
    
    
    static func createLogin(email: String, password: String) {
        
        do {
            let query = LoginQuery(email: email, password: password)
            let request = try Router.login(query: query).asURLRequest()
            
            AF.request(request).responseDecodable(of: LoginModel.self) { response in
                
                switch response.result {
                case .success(let value):
                    
                    //                    let vc = ProfileViewController()
                    //                    vc.accessToken = value.accessToken
                    
                    UserDefaultManager.shared.accessToken = value.accessToken
                    UserDefaultManager.shared.refreshToken = value.refreshToken
                    
                    print(value)
                case .failure(let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
   
        
    }
    
}
