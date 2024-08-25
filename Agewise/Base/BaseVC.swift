//
//  BaseVC.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import UIKit

class BaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black

        
        bind()
        configureNavigationBar()
    }
    
    func bind() { }
    func configureNavigationBar() {}
}

