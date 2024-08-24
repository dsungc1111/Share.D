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
