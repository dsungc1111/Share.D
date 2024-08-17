//
//  SignInViewModel.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let signInTap: ControlEvent<Void>
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
    }
    
    struct Output {
        let login: PublishSubject<Int>
        let emailValid: Observable<Bool>
        let pwValid: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let login = PublishSubject<Int>()
        
//        let userInfo = Observable.zip(input.emailText, input.passwordText)
//        
//        
        var email = ""
        var password = ""
        
        input.emailText
            .bind(with: self) { owner, value in
                email = value
            }
            .disposed(by: disposeBag)
        
        let emailValid =  input.emailText
            .map { $0.contains("@") }
        
        input.passwordText
            .bind(with: self) { owner, value in
                password = value
            }
            .disposed(by: disposeBag)
        
        let pwValid = input.passwordText.map { $0.count >= 8 }
        
        input.signInTap
            .subscribe(with: self) { owner, _ in
               
                print(email, password)
                NetworkManager.shared.createLogin(email: email, password: password) { response in
                    switch response {
                    case .success(let value):
                        UserDefaultManager.shared.accessToken = value.accessToken
                        UserDefaultManager.shared.refreshToken = value.refreshToken
                        login.onNext(0)
                    case .failure(_):
                        login.onNext(1)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(login: login, emailValid: emailValid, pwValid: pwValid)
    }
}
