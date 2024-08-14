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
        
       
        
        
        signUpView.signUpButton.rx.tap
            .subscribe(with: self) { owner, _ in
                guard let email = owner.signUpView.emailTextField.text else { return }
                guard let password = owner.signUpView.passwordTextField.text else { return }
                guard let nickname = owner.signUpView.nicknameTextField.text else { return }

                
                NetworkManager.join(email: email, password: password, nickname: nickname) { result in
                    
                    switch result {
                    case .success(let value):
                        print(value)
                        let vc = SignInVC()
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .failure(let error):
                        print(error)
                    }
                }
                

            }
            .disposed(by: disposeBag)
        
    }
    
    
    
}
