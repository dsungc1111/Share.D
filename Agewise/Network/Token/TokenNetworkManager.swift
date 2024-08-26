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
                    }
                }
            }
    }
    
    func tokenNetworkManager<T: Decodable>(api: TokenRouter, model: T.Type) -> Single<(statuscode: Int, data: T?)> {
        return Single.create { observer in
            AF.request(api)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    guard let statuscode = response.response?.statusCode else { return }
                    
                    print("토큰 확인 =", statuscode)
                    
                    
                    switch response.result {
                    case .success(let value):
                        print("성공")
                        observer(.success((statuscode: statuscode, data: value)))
                        
                    case .failure(_):
                        print("실패")
                        if statuscode == 419 {
                            // 토큰 리프레시 요청
                            self.tokenNetworkManager(api: .refresh, model: T.self)
                                .subscribe(onSuccess: { refreshResult in
                                    
                                    print(refreshResult.statuscode)
                                    if refreshResult.statuscode == 200 {
                                        // 리프레시 성공 시, 갱신된 토큰 저장
                                        if let newToken = refreshResult.data as? RefreshModel {
                                            UserDefaultManager.shared.accessToken = newToken.accessToken
                                            print("저장?")
                                        }
                                        // 다시 fetchProfile 요청
                                        self.tokenNetworkManager(api: .fetchProfile, model: T.self)
                                            .subscribe(onSuccess: { fetchProfileResult in
                                                observer(.success((statuscode: fetchProfileResult.statuscode, data: fetchProfileResult.data)))
                                            })
                                            .disposed(by: DisposeBag())
                                    } else {
                                        observer(.success((statuscode: refreshResult.statuscode, data: nil)))
                                    }
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
