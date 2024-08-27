//
//  TabBarController.swift
//  Agewise
//
//  Created by 최대성 on 8/19/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        
        
    }
    
    private func setTabBar() {
        let settingVC = UINavigationController(rootViewController: SettingVC())
        let promotionVC = UINavigationController(rootViewController: PromotionVC())
        let postListVC = UINavigationController(rootViewController: PostListVC())
    
        settingVC.tabBarItem = UITabBarItem(title: "세팅", image: UIImage(systemName: "gearshape"), tag: 0)
        promotionVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 1)
        postListVC.tabBarItem = UITabBarItem(title: "질문", image: UIImage(systemName: "questionmark.bubble"), tag: 2)
        setViewControllers([postListVC, promotionVC, settingVC], animated: true)
        
        self.tabBar.tintColor = UIColor(red: 64/255, green: 120/255, blue: 187/255, alpha: 1)
        self.selectedIndex = 1
    }
}


/*
 TokenNetworkManager.shared.networking(api: .fetchProfile, model: ProfileModel.self) { statuscode, result in
     print("스테이터스코드", statuscode)
     
     if statuscode == 200 {
         UserDefaultManager.shared.userNickname = result?.nick ?? ""
         UserDefaultManager.shared.userId = result?.id ?? ""
         print(UserDefaultManager.shared.userNickname)
     } else if statuscode == 419 {
         
         TokenNetworkManager.shared.networking(api: .refresh, model: RefreshModel.self) { statuscode, result in
             
             if statuscode == 200 {
                 UserDefaultManager.shared.accessToken = result?.accessToken ?? ""
                 
                 TokenNetworkManager.shared.networking(api: .fetchProfile, model: ProfileModel.self) { statuscode, result in
                     
                 }
             } else if statuscode == 418 {
                 let message = owner.judgeStatusCode(statusCode: statuscode, title: "로그인 만료")
                 logout.onNext(message)
             }
         }
     }
 }
 
 */
