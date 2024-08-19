//
//  SignUpViewModel.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: BaseViewModel {
    
    deinit {
        print("signupViewModel deinit!!")
    }
    
    struct Input {
        let sigUpTap: ControlEvent<Void>
        let validaionTap: ControlEvent<Void>
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
        let nicknameText: ControlProperty<String>
    }
    struct Output {
        let success: PublishSubject<String>
        let validation: PublishSubject<String>
        let emailValid: Observable<Bool>
        let pwValid: Observable<Bool>
        let nicknameValid: Observable<Bool>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let success = PublishSubject<String>()
        let validation = PublishSubject<String>()
        

        
        var email = ""
        var password = ""
        var nickname = ""
        
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
        
        input.nicknameText
            .bind(with: self) { owner, value in
                nickname = value
            }
            .disposed(by: disposeBag)
        
        let nicknameValid = input.nicknameText.map { $0.count >= 2 }
        
        
        
        input.validaionTap
            .bind(with: self) { owner, _ in
                
                if email.contains("@") {
                    NetworkManager.shared.checkEmailValidation(email: email) { result in
                        
                        validation.onNext(owner.judgeStatusCode(statusCode: result, title: "사용 가능한 이메일입니다."))
                        
                    }
                } else {
                    validation.onNext("email 형식을 지켜주세요 - @필수")
                }
            }
            .disposed(by: disposeBag)
        
        
        input.sigUpTap
            .subscribe(with: self, onNext: { owner, _ in
                
                NetworkManager.shared.join(email: email, password: password, nickname: nickname) { result in
                    
                    success.onNext(owner.judgeStatusCode(statusCode: result, title: "회원가입 성공!"))
                }
            })
            .disposed(by: disposeBag)
        
        return Output(success: success, validation: validation, emailValid: emailValid, pwValid: pwValid, nicknameValid: nicknameValid)
    }
    
    // 메시지 전달

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
