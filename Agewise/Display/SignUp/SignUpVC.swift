//
//  SignUpVC.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpVC: BaseVC {
    
    private let signUpView = SignUpView()
    
    private let signUpViewModel = SignUpViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let input = SignUpViewModel.Input(sigInTap: signUpView.signUpButton.rx.tap, emailText: signUpView.emailTextField.rx.text.orEmpty, passwordText: signUpView.passwordTextField.rx.text.orEmpty, nicknameText: signUpView.nicknameTextField.rx.text.orEmpty)
        
        
        let output = signUpViewModel.transform(input: input)
        
        
        output.success
            .bind(with: self) { owner, result in
                if result == 0 {
                    let vc = SignInVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    print("실패")
                }
            }
            .disposed(by: disposeBag)
       
        
        
    }
    
    
    
}
