//
//  SignInVC.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignInVC: BaseVC {
    
    private let signInView = SignInView()
    
    private let signInViewModel = SignInViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let input = SignInViewModel.Input(signInTap: signInView.signInButton.rx.tap, emailText: signInView.emailTextField.rx.text.orEmpty, passwordText: signInView.passwordTextfield.rx.text.orEmpty)
        
        let output = signInViewModel.transform(input: input)
        
        output.login
            .bind(with: self) { owner, result in
                
                if result == 0 {
                    let vc = MainVC()
                    owner.navigationController?.pushViewController(vc, animated: true)
                } else {
                    print("로그인 불가")
                }
            }
            .disposed(by: disposeBag)
        
        
    }
    
    
    
    
}
