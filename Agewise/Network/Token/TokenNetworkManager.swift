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
    
    private let disposeBag = DisposeBag()
    
    static let shared = TokenNetworkManager()
    
    private init() {}
    
    
    func networking<T: Decodable>(api: TokenRouter, model: T.Type, completionHandler: @escaping (Int, T?) -> Void) {
        
        let url = api.baseURL + api.path
        
        
        AF.request(url, method: api.method, encoding: URLEncoding(destination: .queryString), headers: HTTPHeaders(api.header))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                
                switch response.result {
                case .success(let value):
                    if let statusCode = response.response?.statusCode {
                        print(statusCode)
                        completionHandler(statusCode, value)
                    }
                case .failure(let error):
                    print("실패 에러 = ", error)
                    if let statusCode = response.response?.statusCode {
                        completionHandler(statusCode, nil)
                        if statusCode == 419 {
                            TokenNetworkManager.shared.networking(api: .refresh, model: RefreshModel.self) { statusCode, result in
                                print("갱신할 액세스 토큰 ", statusCode)
                                UserDefaultManager.accessToken = result?.accessToken ?? ""
                                self.networking(api: api, model: model, completionHandler: completionHandler)
                            }
                        }
                    }
                }
            }
    }
    func tokenNetwork<T: Decodable>(api: TokenRouter, model: T.Type) -> Single<(statuscode: Int, data: T?)> {
        return Single.create { observer in

            AF.request(api)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    guard let statuscode = response.response?.statusCode else {
                        observer(.success((statuscode: 0, data: nil)))
                        return
                    }
                    
                    switch response.result {
                    case .success(let value):
                        print("성공")
                        observer(.success((statuscode: statuscode, data: value)))
                        
                    case .failure(_):
                        print("실패")
                        print("실패 스테이터스 코드",statuscode)
                        if statuscode == 419 {
                            // 토큰 리프레시 요청
                            self.tokenNetwork(api: .refresh, model: RefreshModel.self)
                                .subscribe(onSuccess: { refreshResult in
                                    
                                    print("리프레시중")
                                    
                                    if refreshResult.statuscode == 200, let newToken = refreshResult.data {
                                        // 갱신된 토큰 저장
                                        UserDefaultManager.accessToken = newToken.accessToken
                                        print("새로운 토큰 저장됨")
                                        
                                        // 원래 요청을 다시 시도
                                        self.tokenNetwork(api: api, model: model)
                                            .subscribe(onSuccess: { retryResult in
                                                observer(.success((statuscode: retryResult.statuscode, data: retryResult.data)))
                                            }, onFailure: { error in
                                                observer(.success((refreshResult.statuscode, nil)))
                                            })
                                            .disposed(by: DisposeBag())
                                    } else {
                                        observer(.success((statuscode: refreshResult.statuscode, data: nil)))
                                    }
                                }, onFailure: { error in
                                    observer(.failure(error))
                                })
                                .disposed(by: DisposeBag())
                        } else {
                            observer(.success((statuscode: statuscode, data: nil)))
                        }
                    }
                }
            return Disposables.create()
        }
    }

}
