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
        print("포스트관련 네트워크 로직")

        do {
            let request = try api.asURLRequest()

            AF.request(request, interceptor: MyNetworkInterceptor())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    
                    guard let statuscode = response.response?.statusCode else { return }
                    
                    switch response.result {
                    case .success(let value):
                        
                        print("성공 statuscode =", statuscode)
                        completionHandler(.success((statuscode, value)))
                        
                    case .failure(let error):
                        print("에러 = ", error)
                        
                        print("실패에러코드 =", statuscode)
                        completionHandler(.failure(.unknownResponse))
                        
                    }
                }
        } catch {
            print("캬치에러", error)
            completionHandler(.failure(.unknownResponse))
        }
    }
    
    func postNetworkManager<T: Decodable>(api: PostRouter, model: T.Type) -> Single<(statusCode: Int, data: T?)> {
        return Single.create { observer in
            print("실행?")
            
            
//            let request = try api.asURLRequest()

            AF.request(api, interceptor: MyNetworkInterceptor())
//            AF.request(api)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    print("실행?????")
                    
                    guard let statuscode = response.response?.statusCode else {
                        observer(.success((statusCode: 0, data: nil)))
                        return
                    }
                    
                    print("스테이터스 코드", statuscode)
                    switch response.result {
                    case .success(let value):
                        
                        print("성공 statuscode =", statuscode)
                        observer(.success((statuscode, value)))
                        
                    case .failure(let error):
                        print("에러 = ", error)
                        
                        print("실패에러코드 =", statuscode)
                        observer(.success((statuscode, nil)))
                        
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
            APIKey.HTTPHeaderName.authorization.rawValue : UserDefaultManager.accessToken,
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

