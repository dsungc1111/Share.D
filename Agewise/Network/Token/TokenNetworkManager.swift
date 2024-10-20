//
//  TokenNetworkManager.swift
//  Agewise
//
//  Created by 최대성 on 8/22/24.
//

import Foundation
import Alamofire
import RxSwift

final class TokenNetworkManager {
    
    static let shared = TokenNetworkManager()
    
    private init() {}

    func tokenNetwork<T: Decodable>(api: TokenRouter, model: T.Type) -> Single<(statuscode: Int, data: T?)> {
        return Single.create { observer in

            AF.request(api, interceptor: MyNetworkInterceptor())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    guard let statuscode = response.response?.statusCode else {
                        observer(.success((statuscode: 0, data: nil)))
                        return
                    }
                    switch response.result {
                        
                    case .success(let value):
                        observer(.success((statuscode: statuscode, data: value)))
                        
                    case .failure(_):
                        observer(.success((statuscode: statuscode, data: nil)))
                    }
                }
            return Disposables.create()
        }
    }

}
