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
            .map {
                let query = LoginQuery(email: email, password: password)
                return query
            }
            .flatMap { value in
                UserNetworkManager.shared.userNetwork(api: .login(query: value), model: LoginModel.self)
            }
            .subscribe(with: self, onNext: { owner, result in
                let message = owner.judgeStatusCode(statusCode: result.statuscode, title: SuccessKeyword.login.rawValue)
                UserDefaultManager.shared.accessToken = result.data?.accessToken ?? ""
                UserDefaultManager.shared.refreshToken = result.data?.refreshToken ?? ""
                success.onNext(message)
            })
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
        case 401:
            message = "이메일과 비밀번호를 확인해주세요."
        default:
            message = "회원이 아닙니다."
        }
        
        return message
    }
}
