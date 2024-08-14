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
        navigationController?.navigationBar.tintColor = .black
        bind()
    }
    
    func bind() { }
}

