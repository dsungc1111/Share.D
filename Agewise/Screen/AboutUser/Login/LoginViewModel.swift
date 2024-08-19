//
//  SignInViewModel.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: BaseViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let signInTap: ControlEvent<Void>
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
    }
    
    struct Output {
        let success: PublishSubject<String>
        let emailValid: Observable<Bool>
        let pwValid: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let success = PublishSubject<String>()
        
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
               
                NetworkManager.shared.createLogin(email: email, password: password) { result in
                    success.onNext(owner.judgeStatusCode(statusCode: result, title: SuccessKeyword.login.rawValue))
                }
            }
            .disposed(by: disposeBag)
        
        return Output(success: success, emailValid: emailValid, pwValid: pwValid)
    }
    
    override func judgeStatusCode(statusCode: Int, title: String) -> String {
        var message = super.judgeStatusCode(statusCode: statusCode, title: title)
        
        switch statusCode {
        case 200 :
            message = title
        case 400:
            message = "필수값을 채워주세요!"
        case 409:
            message = "이미 가입한 유저에요!"
        default:
            message = "기타 에러"
        }
        
        return message
    }
}
