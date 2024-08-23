//
//  TokenNetworkManager.swift
//  Agewise
//
//  Created by 최대성 on 8/22/24.
//

import Foundation
import Alamofire
import UIKit

final class TokenNetworkManager {
    
    
    static let shared = TokenNetworkManager()
    
    private init() {}
    
    
    //MARK: - 리프레시
    func refreshToken() {
        do {
            let request = try Router.refresh.asURLRequest()
            AF.request(request).responseDecodable(of: RefreshModel.self) { response in
                
                guard let statusCode = response.response?.statusCode else { return }
                
                print("리프레쉬 statusCdoe =", statusCode)
                
                if response.response?.statusCode == 418 {
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    let sceneDelegate = windowScene?.delegate as? SceneDelegate
                    let vc = OnBoardingVC()
                    let navigationController = UINavigationController(rootViewController: vc)
                    
                    sceneDelegate?.window?.rootViewController = navigationController
                    sceneDelegate?.window?.makeKeyAndVisible()
                }
                switch response.result {
                case .success(let value):
           
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
                  
                    print("초기화 해야겠죠?")
                    
                    UserDefaultManager.shared.removeAll()
                    
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    let sceneDelegate = windowScene?.delegate as? SceneDelegate
                    let vc = OnBoardingVC()
                    let navigationController = UINavigationController(rootViewController: vc)
                    
                    sceneDelegate?.window?.rootViewController = navigationController
                    sceneDelegate?.window?.makeKeyAndVisible()
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
