//
//  SignUpViewModel.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel {
    
    
    struct Input {
        let sigInTap: ControlEvent<Void>
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
        let nicknameText: ControlProperty<String>
    }
    struct Output {
        let success: PublishSubject<Int>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let success = PublishSubject<Int>()
        
        let userInfo = Observable.zip(input.emailText, input.passwordText, input.nicknameText)
        
        input.sigInTap
            .withLatestFrom(userInfo)
            .subscribe(with: self, onNext: { owner, result in
                
                let email = result.0
                let password = result.1
                let nickname = result.2
                // 이메일이 유효할 때만 가입절차 진행
                
                NetworkManager.shared.checkEmailValidation(email: result.0) { result in
                    switch result {
                    case .success(let value):
                        print(value)
                        NetworkManager.shared.join(email: email, password: password, nickname: nickname) { result in
                            switch result {
                            case .success(_):
                                success.onNext(0)
                            case .failure(_):
                                success.onNext(1)
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        return Output(success: success)
    }
}
