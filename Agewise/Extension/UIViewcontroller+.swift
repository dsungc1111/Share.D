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
    
    
    
    func withdrawUser(completionHandler: @escaping ((String) -> Void)) {
        
        
//        
        let alert = UIAlertController(title: "탈퇴", message: "탈퇴하시겠습니까?", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "확인", style: .default)
        { _ in
            completionHandler("확인")
            
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
        let cancelButton = UIAlertAction(title: "취소", style: .cancel) {
            _  in
            completionHandler("취소")
        }
        
        
        
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
    }
}
