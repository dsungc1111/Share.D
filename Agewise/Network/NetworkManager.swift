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
    
    
    //MARK: - 회원가입
    func join(email: String, password: String, nickname: String, completionHandler: @escaping (Int?) -> Void) {
        do {
            let query = JoinQuery(email: email, password: password, nick: nickname)
            let request = try Router.join(query: query).asURLRequest()
            
            AF.request(request).responseDecodable(of: JoinModel.self) { response in
                
                switch response.result {
                case .success(let value):
                    print(value)
                    guard let responseStatusCode = response.response?.statusCode else { return }
                    completionHandler(responseStatusCode)
                case .failure( _):
                    guard let responseStatusCode = response.response?.statusCode else { return }
                    completionHandler(responseStatusCode)
                }
            }
        } catch {
            completionHandler(500)
        }
    }
    //MARK: - 회원가입 - 이메일중복 확인
    func checkEmailValidation(email: String, completionHandler: @escaping (Int?) -> Void) {
        
        do {
            let query = EmailValidationQuery(email: email)
            
            let request = try Router.emailValidation(query: query).asURLRequest()
            
            AF.request(request).responseDecodable(of: EmailValidationModel.self) { response in
                
                switch response.result {
                case .success(let value):
                    print(value)
                    guard let responseStatusCode = response.response?.statusCode else { return }
                    completionHandler(responseStatusCode)
                case .failure(_):
                    guard let responseStatusCode = response.response?.statusCode else { return }
                    completionHandler(responseStatusCode)
                }
            }
            
        } catch {
            print("에러")
        }
    }
    
    //MARK: - 로그인
    func createLogin(email: String, password: String, completionHandler: @escaping (Result<LoginModel, NetworkError>) -> Void) {
        
        do {
            let query = LoginQuery(email: email, password: password)
            let request = try Router.login(query: query).asURLRequest()
            
            AF.request(request).responseDecodable(of: LoginModel.self) { response in
                
                switch response.result {
                case .success(let value):
                    completionHandler(.success(value))
                case .failure(let error):
                    print(error)
                    completionHandler(.failure(NetworkError.unknownResponse))
                }
            }
        } catch {
            print(error)
        }
    }
    
    //MARK: - 리프레시
    func refreshToken() {
        do {
            let request = try Router.refresh.asURLRequest()
            AF.request(request).responseDecodable(of: RefreshModel.self) { response in
                
                guard let statusCode = response.response?.statusCode else { return }
                
                print("리프레쉬 statusCdoe =", statusCode)
                
                if response.response?.statusCode == 418 {
                    // 리프레시 토큰 만료 > 다시 로그인 필요
                    for key in UserDefaults.standard.dictionaryRepresentation().keys {
                        UserDefaults.standard.removeObject(forKey: key.description)
                    }
                    
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let sceneDelegate = windowScene.delegate as? SceneDelegate,
                       let window = sceneDelegate.window {
                        
                        let onboardingVC = OnBoardingVC()
                        let navController = UINavigationController(rootViewController: onboardingVC)
                        window.rootViewController = navController
                        window.makeKeyAndVisible()
                    }
                }
                switch response.result {
                case .success(let value):
                    print("refresh완료")
//                    UserDefaults.standard.setValue(value.accessToken, forKey: UserDefaultManager.shared.accessToken)
                    UserDefaultManager.shared.accessToken = value.accessToken
                    self.fetchProfile()
                case .failure(let error):
                    print(error)
                }
            }
        } catch {
            
        }
    }
    //MARK: - 프로필 조회
    // 액세스 토큰 만료되면 > 리프레시 토큰을 액세스 토큰에 넣어주고
    // 액세스 토큰이 만료되면 > 처음 시작 화면으로
    func fetchProfile() {
        
        do {
            let request = try Router.fetchProfile.asURLRequest()
            
            AF.request(request).responseDecodable(of: ProfileModel.self) { response in
                
                guard let responseCode = response.response?.statusCode else { return }
                
                print("프로필 조회 = ", responseCode)
                
                if responseCode == 419 {
                    print("토큰만료하여 리푸레쉬토근해야합니다")
                   self.refreshToken()
                } else if responseCode == 401 {
                    print("인증할 수 없는 토큰입니다.")
                } else if responseCode == 403 {
                    print("접근권한 XX")
                } else {
                    print("ok")
                    switch response.result {
                    case .success(let value):
                        print(value)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        } catch {
            print("URLRequestConvertible에서 asURLRequest로 요청 만드는 거 실패", error)
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
            "display" : 40
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
