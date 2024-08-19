//
//  UIViewcontroller+.swift
//  Agewise
//
//  Created by 최대성 on 8/18/24.
//

import UIKit

extension UIViewController {
    
    //MARK:- 화면 초기화
    
    func resetView(vc: UIViewController) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let navigationController = UINavigationController(rootViewController: vc)
        
        sceneDelegate?.window?.rootViewController = navigationController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func expiredToken() {
        
        let alert = UIAlertController(title: "로그인 만료", message: "계정 정보 만료", preferredStyle: .alert)
        
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
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        
        
        
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
    }
}
