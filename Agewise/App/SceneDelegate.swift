//
//  SceneDelegate.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func setTabBarController(scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
    
        window = UIWindow(windowScene: windowScene)

        let tabBarController = UITabBarController()
    
        let settingVC = UINavigationController(rootViewController: SettingVC())
        let promotionVC = UINavigationController(rootViewController: PromotionVC())
        let questionVC = UINavigationController(rootViewController: QuestionVC())
    
        settingVC.tabBarItem = UITabBarItem(title: "세팅", image: UIImage(systemName: "gearshape"), tag: 0)
        promotionVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 1)
        questionVC.tabBarItem = UITabBarItem(title: "질문", image: UIImage(systemName: "questionmark.bubble"), tag: 2)
    
        tabBarController.viewControllers = [questionVC, promotionVC, settingVC]
        tabBarController.selectedIndex = 1
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        setTabBarController(scene: scene)
//        window = UIWindow(windowScene: scene)
//        
//        let vc = UINavigationController(rootViewController: PromotionVC())
//        window?.rootViewController = vc
//        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

