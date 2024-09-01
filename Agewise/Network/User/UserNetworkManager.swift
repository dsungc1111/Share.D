//
//  UserNetworkManager.swift
//  Agewise
//
//  Created by 최대성 on 8/22/24.
//

import Foundation
import Alamofire
import RxSwift


final class UserNetworkManager {
    
    static let shared = UserNetworkManager()
    
    private init() {}
    
    func userNetwork<T: Decodable>(api: UserRouter, model: T.Type) -> Single<(statuscode: Int, data: T?)> {
        return Single.create { observer in
            
            AF.request(api)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    
                    guard let statuscode = response.response?.statusCode else { return }
                    
                    switch response.result {
                    case .success(let value):
                        observer(.success((statuscode: statuscode, data: value)))
                    case .failure(let error):
                        print(error)
                        observer(.success((statuscode: statuscode, data: nil)))
                    }
                }
            return Disposables.create()
        }
    }
    
    func userUploadNetwork<T: Decodable>(api: UserRouter, model: T.Type) -> Single<(statuscode: Int, data: T?)> {
        return Single.create { observer in
            AF.upload(multipartFormData: api.multipartFormData, with: api)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    
                    guard let statuscode = response.response?.statusCode else { return }
                    
                    switch response.result {
                    case .success(let value):
                        observer(.success((statuscode: statuscode, data: value)))
                        
                        
                    case .failure(let error):
                        print(error)
                        observer(.success((statuscode: statuscode, data: nil)))
                    }
                }
            return Disposables.create()
        }
    }
   
    
}
