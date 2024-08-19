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
        let questionVC = UINavigationController(rootViewController: QuestionListVC())
    
        settingVC.tabBarItem = UITabBarItem(title: "세팅", image: UIImage(systemName: "gearshape"), tag: 0)
        promotionVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 1)
        questionVC.tabBarItem = UITabBarItem(title: "질문", image: UIImage(systemName: "questionmark.bubble"), tag: 2)
        setViewControllers([questionVC, promotionVC, settingVC], animated: true)
        self.selectedIndex = 1
    }
}