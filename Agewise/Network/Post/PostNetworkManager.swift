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
    
    func postNetwork<T: Decodable>(api: PostRouter, model: T.Type) -> Single<(statusCode: Int, data: T?)> {
        return Single.create { observer in

            AF.request(api, interceptor: MyNetworkInterceptor())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    
                    guard let statuscode = response.response?.statusCode else {
                        observer(.success((statusCode: 500, data: nil)))
                        return
                    }
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
    
//    func delete(api: PostRouter, completionHandler: @escaping (Result<Int, NetworkError>) -> Void) {
//        
//        let url = api.baseURL + api.path
//        
//        AF.request(url, method: api.method, encoding: URLEncoding(destination: .queryString), headers: HTTPHeaders(api.header))
//            .validate(statusCode: 200..<300)
//            .response { response in
//                switch response.result {
//                case .success(let value):
//                    if let statusCode = response.response?.statusCode {
//                        print(statusCode)
//                        completionHandler(.success(statusCode))
//                    } else {
//                        completionHandler(.failure(.invalidURL))
//                    }
//                case .failure(let error):
//                    print(error)
//                    if let statusCode = response.response?.statusCode {
//                        completionHandler(.failure(.unknownResponse))
//                        
//                    } else {
//                        completionHandler(.failure(.unknownResponse))
//                    }
//                }
//            }
//    }
  
    
    
}

