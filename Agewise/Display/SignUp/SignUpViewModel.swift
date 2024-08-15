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
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
        let nicknameText: ControlProperty<String>
    }
    struct Output {
        let success: PublishSubject<String>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let success = PublishSubject<String>()
        
        var email = ""
        var password = ""
        var nickname = ""
        
        input.emailText
            .bind(with: self) { owner, value in
                email = value
            }
            .disposed(by: disposeBag)
        
        input.passwordText
            .bind(with: self) { owner, value in
                password = value
            }
            .disposed(by: disposeBag)
        
        input.nicknameText
            .bind(with: self) { owner, value in
                nickname = value
            }
            .disposed(by: disposeBag)
        
        
        
        if email.contains("@") {
            NetworkManager.shared.checkEmailValidation(email: email) { result in
                switch result {
                case .success(let value):
                    print("value =", value)
                        
                case .failure(let error):
                    print("error =",error)
                }
            }
        } else {
            success.onNext("email 형식을 지켜주세요 - @필수")
        }
        
        
        input.sigUpTap
            .subscribe(with: self, onNext: { owner, _ in
                // 이메일이 유효할 때만 가입절차 진행
                
                NetworkManager.shared.join(email: email, password: password, nickname: nickname) { result in
                    
                    if let statuscode = result {
                        success.onNext(owner.judgeStatusCode(statusCode: statuscode))
                    }
                }
            })
            .disposed(by: disposeBag)
        
        return Output(success: success)
    }
    
    // 메시지 전달
    override func judgeStatusCode(statusCode: Int) -> String {
        
        var message = super.judgeStatusCode(statusCode: statusCode)
        
        switch statusCode {
        case 200 :
            message = "회원가입 성공!"
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
