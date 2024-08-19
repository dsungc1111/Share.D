//
//  QuestionVC.swift
//  Agewise
//
//  Created by 최대성 on 8/15/24.
//

import Foundation


final class QuestionVC: BaseVC {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        NetworkManager.shared.fetchProfile()
        
    }
}
