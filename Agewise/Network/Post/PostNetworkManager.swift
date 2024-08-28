//
//  PostNetworkManager.swift
//  Agewise
//
//  Created by 최대성 on 8/23/24.
//

import Foundation
import Alamofire
import RxSwift

final class PostNetworkManager {
    
    static let shared = PostNetworkManager()
    
    private init() {}
    
    
    func networking<T: Decodable>(api: PostRouter, model: T.Type, completionHandler: @escaping (Result<(Int, T), NetworkError>) -> Void) {
        print("이거실행")
      do {
          
        let request = try api.asURLRequest()
          print(request)
        AF.request(request)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                
                print("안되는 거임?")
                
                switch response.result {
                case .success(let value):
                    print("성공")
                    if let statusCode = response.response?.statusCode {
                        print("성공 =", statusCode)
                        completionHandler(.success((statusCode, value)))
                    }
                case .failure(let error):
                    print("에러 =", error)
                    if let statusCode = response.response?.statusCode {
                        completionHandler(.failure(.unknownResponse))
                        print(statusCode)
                        if statusCode == 419 {
                            TokenNetworkManager.shared.networking(api: .refresh, model: RefreshModel.self) { statusCode, result in
                                UserDefaultManager.shared.accessToken = result?.accessToken ?? ""
                            }
                        } else if statusCode == 418 {
                            print("재로그인")
                        }
                    }
                }
            }
    } catch {
        print("Request creation failed with error:")
        completionHandler(.failure(.unknownResponse))
    }
    }
    
    
    func postNetworkManager<T: Decodable>(api: PostRouter, model: T.Type) -> Single<(statuscode: Int, data: T?)> {
        
        return Single.create { observer in
            
            print("실행?")
            AF.request(api)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    print("실행?????")
                    guard let statuscode = response.response?.statusCode else { return }
                    
                    print(response.result)
                    switch response.result {
                    case .success(let value):
                        print("value = ",value)
                        observer(.success((statuscode: statuscode, data: value)))
                        
                    case .failure(let error):
                        print(error)
                        observer(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }
    
    func delete(api: PostRouter, completionHandler: @escaping (Result<Int, NetworkError>) -> Void) {
        
        let url = api.baseURL + api.path
        
        AF.request(url, method: api.method, encoding: URLEncoding(destination: .queryString), headers: HTTPHeaders(api.header))
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success(let value):
                    if let statusCode = response.response?.statusCode {
                        print(statusCode)
                        completionHandler(.success(statusCode))
                    } else {
                        completionHandler(.failure(.invalidURL))
                    }
                case .failure(let error):
                    print(error)
                    if let statusCode = response.response?.statusCode {
                        completionHandler(.failure(.unknownResponse))
                        
                    } else {
                        completionHandler(.failure(.unknownResponse))
                    }
                }
            }
    }
    
    
    
    func commentCreate(postId: String, comment: String, completionHandler: @escaping (Int) -> Void) {
        
        let url = APIKey.baseURL  + "v1/posts/\(postId)/comments"
        
        
        let headers: HTTPHeaders = [
            APIKey.HTTPHeaderName.authorization.rawValue : UserDefaultManager.shared.accessToken,
            APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.DeveloperKey,
            APIKey.HTTPHeaderName.contentType.rawValue :  APIKey.HTTPHeaderName.json.rawValue
        ]
        
        let param: [String: String] = [
            "content" : comment
        ]
        
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: LikeModel.self) { result in
                switch result.result {
                    
                case .success(let value):
                    if let code = result.response?.statusCode {
                        completionHandler(code)
                    }
                    print(value)
                case .failure(let error):
                    print(error)
                    if let code = result.response?.statusCode {
                        completionHandler(code)
                    }
                }
            }
    }
    
    
}
