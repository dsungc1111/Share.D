//
//  PostDetailVC.swift
//  Agewise
//
//  Created by 최대성 on 8/21/24.
//

import UIKit

final class PostDetailVC: BaseVC {

    private let postDetailView = PostDetailView()
    
    var element: PostModelToWrite?
    
    override func loadView() {
        view = postDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

   

}
