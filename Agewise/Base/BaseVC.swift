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
        navigationController?.navigationBar.tintColor = UIColor(red: 64/255, green: 120/255, blue: 187/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red: 64/255, green: 120/255, blue: 187/255, alpha: 1)]
        
        bind()
        configureNavigationBar()
    }
    
    func bind() { }
    func configureNavigationBar() {}
}

