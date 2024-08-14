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


final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    
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
