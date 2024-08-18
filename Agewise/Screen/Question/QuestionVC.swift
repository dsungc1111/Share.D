//
//  QuestionVC.swift
//  Agewise
//
//  Created by 최대성 on 8/15/24.
//

import Foundation


final class QuestionVC: BaseVC {
    
    var accessToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accessToken = UserDefaultManager.shared.accessToken
        
        print(accessToken)
        
        NetworkManager.shared.fetchProfile()
    }
}
