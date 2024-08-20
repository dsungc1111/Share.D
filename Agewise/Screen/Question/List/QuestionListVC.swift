//
//  QuestionListVC.swift
//  Agewise
//
//  Created by 최대성 on 8/15/24.
//

import Foundation


final class QuestionListVC: BaseVC {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NetworkManager.shared.fetchProfile()
        
        let aa = GetPostQuery(next: "", limit: "10", product_id: "10대선물용")
        NetworkManager.shared.getPost(query: aa)
    }
}
