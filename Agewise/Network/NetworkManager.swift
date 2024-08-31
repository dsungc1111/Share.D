//
//  NetworkManager.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import UIKit
import Alamofire
import RxSwift



final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    
    
    //MARK: - 포스트 작성
    func writePost(query: PostQuery, completionHandler: @escaping (Int) -> Void) {
        do {
            let request = try Router.postQuestion(query: query).asURLRequest()
            
            AF.request(request).responseDecodable(of: PostModelToWrite.self) { response in
                
                guard let responseCode = response.response?.statusCode else { return }
                
                print("포스트 작성 = ", responseCode)
                
                switch response.result {
                case .success(let value):
                    print(value)
                    
                    completionHandler(responseCode)
                case .failure(_):
                    //                    guard let responseStatusCode = response.response?.statusCode else { return }
                    completionHandler(responseCode)
                }
                
            }
        } catch {
            print("URLRequestConvertible에서 asURLRequest로 요청 만드는 거 실패", error)
            completionHandler(500)
        }
    }
    
    //MARK: - 포스트 조회
    func getPost(query: GetPostQuery) -> Single<Result<PostModelToView, NetworkError>> {
        return Single.create { observer -> Disposable in
            
//            let session = Session(interceptor: MyNetworkInterceptor())
            
            do {
                let request = try Router.getPost(query: query).asURLRequest()
                
//                session.request(request)
                AF.request(request)
                    .validate(statusCode: 200..<300)
//                    .responseString { result in
//                        print(result)
//                    }
                    .responseDecodable(of: PostModelToView.self) { response in
                   
//                        if let responseCode = response.response?.statusCode {
//                            print("포스트 조회 = ", responseCode)
//                        } else {
//                            print("Response is nil")
//                            observer(.failure(NetworkError.invalidURL))
//                            return
//                        }
                        
                        
                        switch response.result {
                        case .success(let value):
                            
                            observer(.success(.success(value)))
                        case .failure(let error):
                            print(error)
                            observer(.success(.failure(.unknownResponse)))
                        }
                    }
            } catch {
                observer(.failure(NetworkError.unknownResponse))
            }
            
            return Disposables.create()
        }
    }
    func viewPost(query: GetPostQuery) -> Single<Result<PostModelToView, NetworkError>> {
        return Single.create { observer -> Disposable in
            
            do {
                let request = try Router.viewPost(query: query).asURLRequest()
                
                AF.request(request)
                    .responseDecodable(of: PostModelToView.self) { response in
                        guard let responseCode = response.response?.statusCode else {
                            observer(.failure(NetworkError.invalidURL))
                            return
                        }
                        
                        print("request = ", request)
                        print("내거 조회 = ", responseCode)
                        
                        switch response.result {
                        case .success(let value):
                            observer(.success(.success(value)))
                        case .failure(let error):
                            print(error)
                            if let statusCode = response.response?.statusCode {
                                print(statusCode)
                                if statusCode == 419 {
                                    TokenNetworkManager.shared.networking(api: .refresh, model: RefreshModel.self) { statusCode, result in
                                        UserDefaultManager.shared.accessToken = result?.accessToken ?? ""
                                    }
                                } else if statusCode == 418 {
                                    print("재로그인")
                                }
                            }
                            observer(.success(.failure(.unknownResponse)))
                        }
                    }
            } catch {
                observer(.failure(NetworkError.unknownResponse))
            }
            return Disposables.create()
        }
    }
    
    func detailPost(query: String) -> Single<Result<PostModelToWrite, NetworkError>> {
        return Single.create { observer -> Disposable in
            do {
                let request = try Router.detailPost(query: query).asURLRequest()
                print("query = ", query)
                
                AF.request(request).responseDecodable(of: PostModelToWrite.self) { response in
                    guard let responseCode = response.response?.statusCode else {
                        observer(.failure(NetworkError.invalidURL))
                        return
                    }
                    
                    print("포스트 조회 = ", responseCode)
                    
                    
                    switch response.result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        print(error)
                        observer(.success(.failure(.unknownResponse)))
                    }
                }
            } catch {
                observer(.failure(NetworkError.unknownResponse))
            }
            return Disposables.create()
        }
    }
    
}

//MARK: - 상품 api 활용
extension NetworkManager {
    
    func naverAPI(query: String, page: Int) -> Single<Result<Product, NetworkError>> {
        
        let url = "https://openapi.naver.com/v1/search/shop.json"
        
        let param: Parameters = [
            "query" : query,
            "page" : page,
            "display" : 10
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
                        observer(.success(.success(value)))
                    case .failure(_):
                        observer(.success(.failure(.unknownResponse)))
                    }
                }
            return Disposables.create()
        }
    }
}


class MyNetworkInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print(#function)
        var request = urlRequest
        
        
        request.setValue(UserDefaultManager.shared.accessToken, forHTTPHeaderField: APIKey.HTTPHeaderName.authorization.rawValue)
        
        print("adator 적용 \(urlRequest.headers)")
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        print("retry 진입")
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 419 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        TokenNetworkManager.shared.tokenNetwork(api: .refresh, model: RefreshModel.self)
            .subscribe(onSuccess: { result in
                if let newToken = result.data?.accessToken {
                    UserDefaultManager.shared.accessToken = newToken
                    completion(.retry)
                } else {
                    completion(.doNotRetry)
                }
            }, onFailure: { _ in
                completion(.doNotRetry)
            })
            .disposed(by: DisposeBag())
    }
}
