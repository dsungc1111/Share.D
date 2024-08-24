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
}
