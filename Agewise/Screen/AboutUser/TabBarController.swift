//
//  TabBarController.swift
//  Agewise
//
//  Created by 최대성 on 8/19/24.
//

import UIKit

//final class TabBarController: UITabBarController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setTabBar()
//        customizeTabBarAppearance()
//        
//    }
//    
//    private func setTabBar() {
//        let settingVC = UINavigationController(rootViewController: SettingVC())
//        let promotionVC = UINavigationController(rootViewController: PromotionVC())
//        let postListVC = UINavigationController(rootViewController: PostListVC())
//        
//        settingVC.tabBarItem = UITabBarItem(title: "MY", image: UIImage(systemName: "person"), tag: 0)
//        promotionVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 1)
//        postListVC.tabBarItem = UITabBarItem(title: "커뮤니티", image: UIImage(systemName: "questionmark.bubble"), tag: 2)
//        setViewControllers([postListVC, promotionVC, settingVC], animated: true)
//        
//        self.tabBar.unselectedItemTintColor = .lightGray
//        self.tabBar.tintColor = .white
//        self.selectedIndex = 1
//    }
//    
//    private func customizeTabBarAppearance() {
//        
//        let tabBarHeight = tabBar.frame.height
//        let radius: CGFloat = 30.0
//        
//        let roundLayer = CAShapeLayer()
//        let shapePath = UIBezierPath(
//            roundedRect: CGRect(x: 10, y: tabBar.bounds.minY - 10, width: tabBar.bounds.width - 20, height: tabBarHeight + 20),
//            cornerRadius: radius
//        )
//        
//        roundLayer.path = shapePath.cgPath
//        roundLayer.fillColor = UIColor.black.cgColor
//        roundLayer.shadowColor = UIColor.black.cgColor
//        roundLayer.shadowOffset = CGSize(width: 0, height: 5)
//        roundLayer.shadowRadius = 10
//        roundLayer.shadowOpacity = 0.1
//        
//        tabBar.layer.insertSublayer(roundLayer, at: 0)
//        tabBar.layer.cornerRadius = radius
//        //           tabBar.layer.masksToBounds = false
//        //           tabBar.clipsToBounds = false
//        tabBar.backgroundColor = .clear
////        tabBar.shadowImage = UIImage()
//        tabBar.isTranslucent = true
//    }
//}


final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        customizeTabBarAppearance()

        // 탭바 배경 제거
        self.tabBar.backgroundImage = UIImage()  // 배경 이미지 제거
        self.tabBar.shadowImage = UIImage()      // 그림자 이미지 제거
        self.tabBar.isTranslucent = true         // 투명도 유지
        self.tabBar.clipsToBounds = false        // 탭바가 경계를 자르지 않도록 설정

        // iOS 15 이상에서 appearance 설정
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()  // 배경을 투명하게 설정
            appearance.backgroundColor = .clear  // 명시적으로 배경을 투명으로 설정
            appearance.shadowImage = nil  // 그림자 제거
            appearance.shadowColor = nil  // 그림자 색상 제거

            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = appearance  // 스크롤 에지에서도 동일하게 설정
        }

        // 플로팅 탭바 뒤에 뷰가 보이도록 설정
        self.tabBar.isTranslucent = true
    }

    private func setTabBar() {
        let settingVC = UINavigationController(rootViewController: SettingVC())
        let promotionVC = UINavigationController(rootViewController: PromotionVC())
        let postListVC = UINavigationController(rootViewController: PostListVC())
        
        settingVC.tabBarItem = UITabBarItem(title: "MY", image: UIImage(systemName: "person"), tag: 0)
        promotionVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 1)
        postListVC.tabBarItem = UITabBarItem(title: "커뮤니티", image: UIImage(systemName: "questionmark.bubble"), tag: 2)
        setViewControllers([postListVC, promotionVC, settingVC], animated: true)
        
        self.tabBar.unselectedItemTintColor = .lightGray
        self.tabBar.tintColor = UIColor(hexCode: "#339CDC", alpha: 1)
        self.selectedIndex = 1
    }

    private func customizeTabBarAppearance() {
        
        let tabBarHeight = tabBar.frame.height
        let radius: CGFloat = 30.0

        let roundLayer = CAShapeLayer()
        let shapePath = UIBezierPath(
            roundedRect: CGRect(x: 10, y: tabBar.bounds.minY - 10, width: tabBar.bounds.width - 20, height: tabBarHeight + 20),
            cornerRadius: radius
        )
        
        roundLayer.path = shapePath.cgPath
        roundLayer.fillColor = UIColor(hexCode: "#cadce7", alpha: 1).cgColor
        roundLayer.shadowColor = UIColor.black.cgColor
        roundLayer.shadowOffset = CGSize(width: 0, height: 5)
        roundLayer.shadowRadius = 10
        roundLayer.shadowOpacity = 0.1
        
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        tabBar.layer.cornerRadius = radius
        tabBar.backgroundColor = .clear
    }
}
