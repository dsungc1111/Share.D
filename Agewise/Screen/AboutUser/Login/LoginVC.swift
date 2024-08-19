//
//  SignInVC.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginVC: BaseVC {
    
    private let loginView = LoginView()
    
    private let loginViewModel = LoginViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        let input = LoginViewModel.Input(signInTap: loginView.signInButton.rx.tap, emailText: loginView.emailTextField.rx.text.orEmpty, passwordText: loginView.passwordTextField.rx.text.orEmpty)
        
        let output = loginViewModel.transform(input: input)
        
        
        output.emailValid
            .bind(with: self) { owner, result in
                owner.loginView.passwordTextField.layer.borderColor = result ? UIColor.black.cgColor : UIColor.lightGray.cgColor
                
            }
            .disposed(by: disposeBag)
        
        output.pwValid
            .bind(with: self) { owner, result in
                
                let color = result ? UIColor.black : UIColor.lightGray
                
                owner.loginView.signInButton.setTitleColor( color , for: .normal)
                owner.loginView.signInButton.layer.borderColor = color.cgColor
                owner.loginView.signInButton.isEnabled = result
            }
            .disposed(by: disposeBag)
            
        
        output.login
            .bind(with: self) { owner, result in
                
                if result == 0 {
                    self.resetViewWithoutNavigation(vc: TabBarController())
                } else {
                    print("로그인 불가")
                }
            }
            .disposed(by: disposeBag)
    }
}
