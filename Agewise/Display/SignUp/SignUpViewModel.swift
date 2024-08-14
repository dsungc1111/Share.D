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
        let emailText: ControlProperty<String?>
        let passwordText: ControlProperty<String?>
        let nicknameText: ControlProperty<String?>
    }
    struct Output {
        let success: PublishSubject<Int>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let success = PublishSubject<Int>()
        
        let userInfo = Observable.zip(input.emailText, input.passwordText, input.passwordText)
        
        input.sigInTap
            .withLatestFrom(userInfo)
            .subscribe(with: self, onNext: { owner, result in
                
                guard let email = result.0 else { return }
                guard let password = result.1 else { return }
                guard let nickname = result.2 else { return }
                
                NetworkManager.checkEmailValidation(email: email) { result in
                    
                    switch result {
                    case .success(let value):
                        print(value)
                    case .failure(let error):
                        print(error)
                    }
                }
                
                
                NetworkManager.join(email: email, password: password, nickname: nickname) { result in
                    
                    switch result {
                    case .success(let value):
                        success.onNext(0)
                    case .failure(let error):
                        success.onNext(1)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        return Output(success: success)
    }
}
