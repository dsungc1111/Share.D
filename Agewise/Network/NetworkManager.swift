//
//  NetworkManager.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import Foundation
import Alamofire
import RxSwift

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
    func checkEmailValidation(email: String, completionHandler: @escaping (Int?) -> Void) {
        
        do {
            let query = EmailValidationQuery(email: email)
            
            let request = try Router.emailValidation(query: query).asURLRequest()
            
            AF.request(request).responseDecodable(of: EmailValidationModel.self) { response in
                
                switch response.result {
                case .success(let value):
                    print(value)
                    guard let responseStatusCode = response.response?.statusCode else { return }
                    completionHandler(responseStatusCode)
                case .failure(_):
                    guard let responseStatusCode = response.response?.statusCode else { return }
                    completionHandler(responseStatusCode)
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

struct Product: Decodable {
    let total: Int
    let start: Int
    let display: Int
    var items: [ProductDetail]
}

struct ProductDetail: Decodable {
    var title: String
    let link: String
    let mallName: String
    let image: String
    let lprice: String
    let productId: String
}

//MARK: - 상품 api 활용
extension NetworkManager {
    
    
    func naverAPI(query: String) -> Single<Result<Product, NetworkError>> {
        
        let url = "https://openapi.naver.com/v1/search/shop.json"
        
        let param: Parameters = [
            "query" : query
        ]
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.searchClientID,
            "X-Naver-Client-Secret" : APIKey.searchClientSecret
        ]
        
        return Single.create { observer -> Disposable in
            
            
            AF.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: header)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Product.self) { response in
                    
                    switch response.result {
                        
                    case .success(let value):
                        print("메서드 진행중")
                        observer(.success(.success(value)))
                    case .failure(let error):
                        print("메서드 실패임")
                        print(error)
                        observer(.success(.failure(.unknownResponse)))
                    }
                    
                }
            
            return Disposables.create()
        }
        
        
      
        
      
    }
    
}
