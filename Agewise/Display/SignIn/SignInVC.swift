//
//  SignInVC.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import UIKit

final class SignInVC: BaseVC {
    
    private let signInView = SignInView()
    
    private let signInViewModel = SignInViewModel()
    
    override func loadView() {
        view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
}
