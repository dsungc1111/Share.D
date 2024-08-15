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
struct EmailValidationQuery: Encodable {
    let email: String
}

enum NetworkError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}
enum NetworkResult<T> {
    case success(T)        // 성공적으로 요청이 완료된 경우, T는 성공 시 반환되는 데이터 타입
    case failure(Error)    // 요청이 실패한 경우, Error 타입의 오류 정보를 반환
}


final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    
    //MARK: - 회원가입
    func join(email: String, password: String, nickname: String, completionHandler: @escaping (Int?) -> Void) {
        do {
            let query = JoinQuery(email: email, password: password, nick: nickname)
            let request = try Router.join(query: query).asURLRequest()
            
            AF.request(request).responseDecodable(of: JoinModel.self) { response in
                
                switch response.result {
                case .success(let value):
                    print(value)
                    guard let responseStatusCode = response.response?.statusCode else { return }
                    completionHandler(responseStatusCode)
                case .failure( _):
                    guard let responseStatusCode = response.response?.statusCode else { return }
                    completionHandler(responseStatusCode)
                }
            }
        } catch {
            completionHandler(500)
        }
    }
    
    
    
    
    
    //MARK: - 회원가입 - 이메일중복 확인
    func checkEmailValidation(email: String, completionHandler: @escaping (Result<EmailValidationModel, NetworkError>) -> Void) {
        
        do {
            let query = EmailValidationQuery(email: email)
            
            let request = try Router.emailValidation(query: query).asURLRequest()
            
            AF.request(request).responseDecodable(of: EmailValidationModel.self) { response in
                
                switch response.result {
                case .success(let value):
                    print(value)
                    completionHandler(.success(value))
                case .failure(let error):
                    print(error)
                    completionHandler(.failure(NetworkError.invalidURL))
                }
            }
            
        } catch {
            
        }
    }
    
    //MARK: - 로그인
    func createLogin(email: String, password: String, completionHandler: @escaping (Result<LoginModel, NetworkError>) -> Void) {
        
        do {
            let query = LoginQuery(email: email, password: password)
            let request = try Router.login(query: query).asURLRequest()
            
            AF.request(request).responseDecodable(of: LoginModel.self) { response in
                
                switch response.result {
                case .success(let value):
                    completionHandler(.success(value))
                case .failure(let error):
                    print(error)
                    completionHandler(.failure(NetworkError.unknownResponse))
                }
            }
        } catch {
            print(error)
        }
   
        
    }
    
}
