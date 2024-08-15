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
        
        let input = SignInViewModel.Input(signInTap: signInView.signInButton.rx.tap, emailText: signInView.emailTextField.rx.text.orEmpty, passwordText: signInView.passwordTextField.rx.text.orEmpty)
        
        let output = signInViewModel.transform(input: input)
        
        
        output.emailValid
            .bind(with: self) { owner, result in
                owner.signInView.passwordTextField.layer.borderColor = result ? UIColor.black.cgColor : UIColor.lightGray.cgColor
                
            }
            .disposed(by: disposeBag)
        
        output.pwValid
            .bind(with: self) { owner, result in
                
                let color = result ? UIColor.black : UIColor.lightGray
                
                owner.signInView.signInButton.setTitleColor( color , for: .normal)
                owner.signInView.signInButton.layer.borderColor = color.cgColor
                owner.signInView.signInButton.isEnabled = result
            }
            .disposed(by: disposeBag)
            
        
        output.login
            .bind(with: self) { owner, result in
                
                if result == 0 {
                    let vc = PromotionVC()
                    owner.navigationController?.pushViewController(vc, animated: true)
                } else {
                    print("로그인 불가")
                }
            }
            .disposed(by: disposeBag)
        
        
    }
    
    
    
    
}
