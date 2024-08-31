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
                        if statusCode == 419 {
                            TokenNetworkManager.shared.networking(api: .refresh, model: RefreshModel.self) { statusCode, result in
                                print("갱신할 액세스 토큰 ", statusCode)
                                UserDefaultManager.shared.accessToken = result?.accessToken ?? ""
                                self.networking(api: api, model: model, completionHandler: completionHandler) 
                            }
                        } else if statusCode == 418 {
                            completionHandler(.failure(.expierdRefreshToken))
                        }
                    }
                }
                
                
            }
    } catch {
        print("Request creation failed with error:")
        completionHandler(.failure(.unknownResponse))
    }
    }
    
    func postNetworkManager<T: Decodable>(api: PostRouter, model: T.Type) -> Single<(statusCode: Int, data: T?)> {
        return Single.create { observer in
            print("실행?")
            
            AF.request(api)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    print("실행?????")
                    
                    guard let statusCode = response.response?.statusCode else {
                        observer(.success((statusCode: 0, data: nil)))
                        return
                    }
                    
                    print("스테이터스 코드", statusCode)
                    
                    if statusCode == 419 {
                        // 토큰 갱신 요청
                        TokenNetworkManager.shared.tokenNetwork(api: .refresh, model: RefreshModel.self)
                            .flatMap { refreshResult -> Single<(statusCode: Int, data: T?)> in
                                
                                print("왜 여기로 안오지?")
                                if refreshResult.statuscode == 200, 
                                    let newToken = refreshResult.data {
                                    UserDefaultManager.shared.accessToken = newToken.accessToken
                                    print("토큰 저장")
                                    
                                    // 토큰 갱신 후 다시 요청
                                    return Single.create { innerObserver in
                                        AF.request(api)
                                            .validate(statusCode: 200..<300)
                                            .responseDecodable(of: T.self) { retryResponse in
                                                let statusCode = retryResponse.response?.statusCode ?? 0
                                                let data = try? retryResponse.result.get()
                                                innerObserver(.success((statusCode: statusCode, data: data)))
                                            }
                                        return Disposables.create()
                                    }
                                    
                                } else {
                                    return Single.just((statusCode: refreshResult.statuscode, data: nil))
                                }
                            }
                            .subscribe(observer)
                            .disposed(by: DisposeBag())
                    } // 419
                    else if statusCode == 418 { // 418
                        print("418임")
                    } else {
                        // 일반 응답 처리
                        let data = try? response.result.get()
                        observer(.success((statusCode: statusCode, data: data)))
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
