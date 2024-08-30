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
        customizeTabBarAppearance()
        
    }
    
    private func setTabBar() {
        let settingVC = UINavigationController(rootViewController: SettingVC())
        let promotionVC = UINavigationController(rootViewController: PromotionVC())
        let postListVC = UINavigationController(rootViewController: PostListVC())
    
        settingVC.tabBarItem = UITabBarItem(title: "세팅", image: UIImage(systemName: "gearshape"), tag: 0)
        promotionVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 1)
        postListVC.tabBarItem = UITabBarItem(title: "커뮤니티", image: UIImage(systemName: "questionmark.bubble"), tag: 2)
        setViewControllers([postListVC, promotionVC, settingVC], animated: true)
        
        self.tabBar.tintColor = UIColor(hexCode: "#c4bee2")
        self.selectedIndex = 1
    }
    
    private func customizeTabBarAppearance() {
           
           let tabBarHeight = tabBar.frame.height
           let radius: CGFloat = 20.0 // 원하는 모서리 둥근 정도
           
           // 배경 뷰 추가
           let roundLayer = CAShapeLayer()
           let shapePath = UIBezierPath(
               roundedRect: CGRect(x: 10, y: tabBar.bounds.minY - 10, width: tabBar.bounds.width - 20, height: tabBarHeight + 20),
               cornerRadius: radius
           )
           
           roundLayer.path = shapePath.cgPath
           roundLayer.fillColor = UIColor.white.cgColor // 배경 색상 설정
           roundLayer.shadowColor = UIColor.black.cgColor
           roundLayer.shadowOffset = CGSize(width: 0, height: 5)
           roundLayer.shadowRadius = 10
           roundLayer.shadowOpacity = 0.1
           
           tabBar.layer.insertSublayer(roundLayer, at: 0)
           tabBar.layer.cornerRadius = radius
//           tabBar.layer.masksToBounds = false
//           tabBar.clipsToBounds = false
           tabBar.backgroundImage = UIImage() // 기본 배경 제거
           tabBar.shadowImage = UIImage() // 기본 그림자 제거
       }
}

