//
//  QuestionVC.swift
//  Agewise
//
//  Created by 최대성 on 8/19/24.
//

import UIKit

final class QuestionVC: BaseVC {

    private let questionView = QuestionView()
    
    override func loadView() {
        view = questionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func configureNavigationBar() {
        navigationItem.title = "질문작성"
    }

}
