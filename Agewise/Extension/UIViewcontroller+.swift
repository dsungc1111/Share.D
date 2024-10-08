//
//  UIViewcontroller+.swift
//  Agewise
//
//  Created by 최대성 on 8/18/24.
//

import UIKit

extension UIViewController {
    
    //MARK:- 화면 초기화
    
    func resetViewWithNavigation(vc: UIViewController) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let navigationController = UINavigationController(rootViewController: vc)
        
        sceneDelegate?.window?.rootViewController = navigationController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func resetViewWithoutNavigation(vc: UIViewController) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    
    
    func withdrawUser(title: String, completionHandler: @escaping (() -> Void)) {
        
        let alert = UIAlertController(title: title, message: "\(title)하시겠습니까?", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "확인", style: .default)
        { _ in
            completionHandler()
            
            for key in UserDefaults.standard.dictionaryRepresentation().keys {
                UserDefaults.standard.removeObject(forKey: key.description)
            }
           
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            let vc = OnBoardingVC()
            let navigationController = UINavigationController(rootViewController: vc)
            
            sceneDelegate?.window?.rootViewController = navigationController
            sceneDelegate?.window?.makeKeyAndVisible()
            
        }
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
    }
    
    func logoutUser() {
        
        let alert = UIAlertController(title: "로그인 만료", message: "로그인 화면으로 돌아갑니다", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "확인", style: .default)
        { _ in
            
            for key in UserDefaults.standard.dictionaryRepresentation().keys {
                UserDefaults.standard.removeObject(forKey: key.description)
            }
           
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            let vc = OnBoardingVC()
            let navigationController = UINavigationController(rootViewController: vc)
            
            sceneDelegate?.window?.rootViewController = navigationController
            sceneDelegate?.window?.makeKeyAndVisible()
            
        }
        
        alert.addAction(okButton)
        
        present(alert, animated: true)
    }
}
