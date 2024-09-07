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
    
    func naverAPI(query: String, start: Int) -> Single<Result<Product, NetworkError>> {
        
        print("쿼리는 \(query), 페이지는 \(start)")
        
        let url = "https://openapi.naver.com/v1/search/shop.json"
        
        let param: Parameters = [
            "query" : query,
            "start" : start,
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
    
    
    private let disposeBag = DisposeBag()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print(#function)
        var request = urlRequest
        
        
        request.setValue(UserDefaultManager.accessToken, forHTTPHeaderField: APIKey.HTTPHeaderName.authorization.rawValue)
        
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
                    UserDefaultManager.accessToken = newToken
                    completion(.retry)
                } else {
                    completion(.doNotRetry)
                }
            }, onFailure: { _ in
                completion(.doNotRetry)
            })
            .disposed(by: disposeBag)
    }
}
