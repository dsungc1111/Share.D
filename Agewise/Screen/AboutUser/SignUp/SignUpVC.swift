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
    override func configureNavigationBar() {
        navigationItem.title = "회원가입"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let input = SignUpViewModel.Input(sigUpTap: signUpView.signUpButton.rx.tap, emailValidaionTap: signUpView.validaionCheckButton.rx.tap, emailText: signUpView.emailTextField.rx.text.orEmpty, passwordText: signUpView.passwordTextField.rx.text.orEmpty, nicknameText: signUpView.nicknameTextField.rx.text.orEmpty)
        
        
        let output = signUpViewModel.transform(input: input)
    
        output.emailValid
            .bind(with: self) { owner, result in
                print(result)
                
                owner.signUpView.passwordTextField.layer.borderColor = result ? UIColor.black.cgColor : UIColor.lightGray.cgColor
                owner.signUpView.passwordWarningLabel.isHidden = result ? false : true
                owner.signUpView.signUpButton.isEnabled = false
                
            }
            .disposed(by: disposeBag)
        
        output.emailCheck
            .bind(with: self) { owner, value in
                owner.signUpView.emailWarningLabel.text = value
            }
            .disposed(by: disposeBag)
        
        output.pwValid
            .bind(with: self) { owner, result in
                owner.signUpView.nicknameTextField.layer.borderColor = result ? UIColor.black.cgColor : UIColor.lightGray.cgColor
                owner.signUpView.passwordWarningLabel.textColor = result ? .black : .red
                owner.signUpView.passwordWarningLabel.text = result ? "비밀번호 조건 부합" : "비밀번호 8글자 이상"
            }
            .disposed(by: disposeBag)
        
        output.readyNickname
            .bind(with: self) { owner, result in
                let color = result ? UIColor.black : UIColor.lightGray
                
                owner.signUpView.signUpButton.setTitleColor( color , for: .normal)
                owner.signUpView.signUpButton.layer.borderColor = color.cgColor
            }
            .disposed(by: disposeBag)

        let signUpValid = Observable.combineLatest(output.emailValid, output.pwValid, output.nicknameValid) { $0 && $1 && $2 }
        
        signUpValid
            .bind(with: self) { owner, result in
                print(result)
                
                owner.signUpView.signUpButton.isEnabled = result
                let color = result ? UIColor.black : UIColor.lightGray
                owner.signUpView.signUpButton.setTitleColor(color, for: .normal)
                owner.signUpView.signUpButton.layer.borderColor = color.cgColor
            }
            .disposed(by: disposeBag)
        
        
        output.statusCode
            .bind(with: self) { owner, result in
                
                if result == SuccessKeyword.signUp.rawValue {
                    owner.resetViewWithNavigation(vc: LoginVC())
                } else {
                    owner.view.makeToast(result, duration: 2.0, position: .bottom)
                }
            }
            .disposed(by: disposeBag)
    }
    
}
