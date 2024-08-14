//
//  SignInViewModel.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignInViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let signInTap: ControlEvent<Void>
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
    }
    
    struct Output {
        let login: PublishSubject<Int>
    }
    
    func transform(input: Input) -> Output {
        
        let login = PublishSubject<Int>()
        
        let userInfo = Observable.zip(input.emailText, input.passwordText)
        
        input.signInTap
            .withLatestFrom(userInfo)
            .subscribe(with: self) { owner, result in
                
                let email = result.0
                let password = result.1
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
        
        return Output(login: login)
    }
}
