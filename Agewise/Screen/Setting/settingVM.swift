//
//  settingVM.swift
//  Agewise
//
//  Created by 최대성 on 8/22/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingVM: BaseViewModel {
    
    enum WithdrawKeyword: String {
        case success = "탈퇴합니다."
    }
    
    struct Input {
        let resetTap: ControlEvent<Void>
        let withdrawButtonTap: PublishSubject<Void>
    }
    struct Output {
        let showResetAlert: PublishSubject<Void>
        let resetMessage: PublishSubject<String>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let showResetAlert = PublishSubject<Void>()
        let resetMessage = PublishSubject<String>()
        
        input.resetTap
            .subscribe(with: self) { owner, _ in
                showResetAlert.onNext(())
            }
            .disposed(by: disposeBag)
        
       
        input.withdrawButtonTap
            .flatMap {
                UserNetworkManager.shared.userNetwork(api: .withdraw, model: ProfileModel.self)
                    .map { $0 }
            }
            .subscribe(with: self, onNext: { owner, result in
                let message = owner.judgeStatusCode(statusCode: result.statuscode, title: WithdrawKeyword.success.rawValue)
                
                resetMessage.onNext(message)
            })
            .disposed(by: disposeBag)
        
        return Output(showResetAlert: showResetAlert, resetMessage: resetMessage)
    }
    
    
    override func judgeStatusCode(statusCode: Int, title: String) -> String {
        var message = super.judgeStatusCode(statusCode: statusCode, title: title)
        
        switch statusCode {
        case 200:
            message = title
        case 401:
            message = "인증할 수 없는 토큰입니다."
        default:
            message = "에러입니다."
        }
        
        return message
    }
}


