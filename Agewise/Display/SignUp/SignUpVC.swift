//
//  SignUpVC.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class SignUpVC: BaseVC {
    
    private let signUpView = SignUpView()
    
    private let signUpViewModel = SignUpViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var showToast: (() -> Void)?
    
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let input = SignUpViewModel.Input(sigUpTap: signUpView.signUpButton.rx.tap, validaionTap: signUpView.validaionCheckButton.rx.tap, emailText: signUpView.emailTextField.rx.text.orEmpty, passwordText: signUpView.passwordTextField.rx.text.orEmpty, nicknameText: signUpView.nicknameTextField.rx.text.orEmpty)
        
        
        let output = signUpViewModel.transform(input: input)
        
        
        
        output.validation
            .bind(with: self) { owner, value in
                owner.signUpView.emailWarningLabel.text = value
            }
            .disposed(by: disposeBag)
        
        
        output.success
            .bind(with: self) { owner, result in
                if result == "회원가입 성공!" {
                    let vc = SignInVC()
                    owner.navigationController?.pushViewController(vc, animated: true)
                } else {
                    owner.view.makeToast(result, duration: 2.0, position: .bottom)
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    
}
