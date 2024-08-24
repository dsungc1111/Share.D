//
//  SignUpViewModel.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import Foundation
import RxSwift
import RxCocoa

enum SignUpSuccessKeyword: String {
    case email = "사용 가능한 이메일입니다."
    case signup = "회원가입 성공!"
}

final class SignUpViewModel: BaseViewModel {
    
    
    struct Input {
        let sigUpTap: ControlEvent<Void>
        let emailValidaionTap: ControlEvent<Void>
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
        let nicknameText: ControlProperty<String>
    }
    struct Output {
        let statusCode: PublishSubject<String>
        let emailCheck: PublishSubject<String>
        let emailValid: Observable<Bool>
        let pwValid: Observable<Bool>
        let nicknameValid: Observable<Bool>
        let readyNickname: Observable<Bool>
    }
    let statusCode = PublishSubject<String>()
    let emailCheck = PublishSubject<String>()
    
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        
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
        
        let pwValid = input.passwordText.map { $0.count >= 8 }
        
        input.nicknameText
            .bind(with: self) { owner, value in
                nickname = value
            }
            .disposed(by: disposeBag)
        
        let nicknameValid = input.nicknameText.map { $0.count >= 2 }
        
        input.emailValidaionTap
            .map {
                let emailtext = EmailValidationQuery(email: email)
                return emailtext
            }
            .flatMap { value in
                UserNetworkManager.shared.userNetwork(api: .emailValidation(query: value), model: EmailValidationModel.self)
            }
            .subscribe(with: self, onNext: { owner, result in
                
                if email.contains("@") {
                    let message = owner.judgeStatusCode(statusCode: result.statuscode, title: SignUpSuccessKeyword.email.rawValue)
                    owner.emailCheck.onNext(message)
                } else {
                    owner.emailCheck.onNext("email 형식을 지켜주세요 - @필수")
                }
            })
            .disposed(by: disposeBag)
        
        let emailValid =  input.emailText
            .map { $0.contains("@")  }
        
        
        let readyNickname = Observable.combineLatest(emailValid, pwValid) { $0 && $1 }
        
        
        input.sigUpTap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .map {
                let query = JoinQuery(email: email, password: password, nick: nickname)
                return query
            }
            .flatMap { query in
                UserNetworkManager.shared.userNetwork(api: .join(query: query), model: JoinModel.self)
            }
            .subscribe(with: self, onNext: { owner, result in
                
                let message = owner.judgeStatusCode(statusCode: result.statuscode, title: SuccessKeyword.signUp.rawValue)
                owner.statusCode.onNext(message)
                
            })
            .disposed(by: disposeBag)
        
        return Output(statusCode: statusCode, emailCheck: emailCheck, emailValid: emailValid, pwValid: pwValid, nicknameValid: nicknameValid, readyNickname: readyNickname)
    }
    
    
    override func judgeStatusCode(statusCode: Int, title: String) -> String {
        var message = super.judgeStatusCode(statusCode: statusCode, title: title)
        
        switch statusCode {
        case 200 :
            message = title
        case 402:
            message = "닉네임 공백 불가"
        case 409:
            message = "이미 가입한 유저에요!"
        default:
            message = "기타 에러"
        }
        
        return message
    }
    
}
