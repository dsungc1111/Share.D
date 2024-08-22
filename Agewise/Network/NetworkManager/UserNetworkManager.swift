//
//  UserNetworkManager.swift
//  Agewise
//
//  Created by 최대성 on 8/22/24.
//

import Foundation
import Alamofire


final class UserNetworkManager {
    
    static let shared = UserNetworkManager()
    
    private init() {}
    
    
    //MARK: - 회원가입
    func join(query: JoinQuery, completionHandler: @escaping (Int) -> Void) {
        do {
            let request = try Router.join(query: query).asURLRequest()
            
            AF.request(request).responseDecodable(of: JoinModel.self) { response in
                
                guard let responseStatusCode = response.response?.statusCode else { return }
                completionHandler(responseStatusCode)
            }
        } catch {
            completionHandler(500)
        }
    }
    
    //MARK: - 회원가입 - 이메일중복 확인
    func checkEmailValidation(email: String, completionHandler: @escaping (Int) -> Void) {
        
        do {
            let query = EmailValidationQuery(email: email)
            let request = try Router.emailValidation(query: query).asURLRequest()
            
            AF.request(request).responseDecodable(of: EmailValidationModel.self) { response in
                guard let responseStatusCode = response.response?.statusCode else { return }
                completionHandler(responseStatusCode)
            }
        } catch {
            completionHandler(500)
        }
    }
    
    //MARK: - 로그인
    func createLogin(query: LoginQuery, completionHandler: @escaping (Int) -> Void) {
        
        do {
            let request = try Router.login(query: query).asURLRequest()
            
            AF.request(request).responseDecodable(of: LoginModel.self) { response in
                
                guard let responseStatusCode = response.response?.statusCode else { return }
                switch response.result {
                case .success(let value):
                    UserDefaultManager.shared.accessToken = value.accessToken
                    UserDefaultManager.shared.refreshToken = value.refreshToken
                    completionHandler(responseStatusCode)
                case .failure(_):
                    completionHandler(responseStatusCode)
                }
            }
        } catch {
            completionHandler(500)
        }
    }
    
    
    //MARK: - 탈퇴하기
    func withdraw(completionHandler: @escaping (Int) -> Void) {
        do {
            let request = try Router.withdraw.asURLRequest()
            
            AF.request(request).responseDecodable(of: ProfileModel.self) { response in
                
                guard let responseStatusCode = response.response?.statusCode else { return }
                
                print("탈퇴하기 = ", responseStatusCode)
                completionHandler(responseStatusCode)
            }
            
        } catch {
           completionHandler(500)
        }
    }
}
