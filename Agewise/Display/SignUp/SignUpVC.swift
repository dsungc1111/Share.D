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
        
        
        output.emailValid
            .bind(with: self) { owner, result in
                
                owner.signUpView.passwordTextField.layer.borderColor = result ? UIColor.black.cgColor : UIColor.lightGray.cgColor
               
            }
            .disposed(by: disposeBag)
        
        output.pwValid
            .bind(with: self) { owner, result in
                owner.signUpView.nicknameTextField.layer.borderColor = result ? UIColor.black.cgColor : UIColor.lightGray.cgColor
            }
            .disposed(by: disposeBag)
        
        
        output.nicknameValid
            .bind(with: self) { owner, result in
                
                let color = result ? UIColor.black : UIColor.lightGray
                
                owner.signUpView.signUpButton.setTitleColor( color , for: .normal)
                owner.signUpView.signUpButton.layer.borderColor = color.cgColor
                owner.signUpView.signUpButton.isEnabled = false
            }
            .disposed(by: disposeBag)
        
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
