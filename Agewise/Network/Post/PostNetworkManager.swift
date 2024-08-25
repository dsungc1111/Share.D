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
        
        let url = api.baseURL + api.path
        
        AF.request(url, method: api.method, encoding: URLEncoding(destination: .queryString), headers: HTTPHeaders(api.header))
            .validate(statusCode: 200..<500)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    if let statusCode = response.response?.statusCode {
                        print(statusCode)
                        completionHandler(.success((statusCode, value)))
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
    
    
    func postNetworkManager<T: Decodable>(api: PostRouter, model: T.Type) -> Single<(statuscode: Int, data: T?)> {
        
        return Single.create { observer in
            
            AF.request(api)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    
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
}
