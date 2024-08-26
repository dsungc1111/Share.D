//
//  settingVM.swift
//  Agewise
//
//  Created by 최대성 on 8/22/24.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class SettingVM: BaseViewModel {
    
    enum WithdrawKeyword: String {
        case success = "탈퇴합니다."
    }
    
    struct Input {
        let myQuestionTap: ControlEvent<Void>
        let logoutTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let withdrawButtonTap: PublishSubject<Void>
    }
    struct Output {
        let showResetAlert: PublishSubject<Void>
        let resetMessage: PublishSubject<String>
        let logoutTap: ControlEvent<Void>
    }
    
    private let disposeBag = DisposeBag()
    private var isLastPage = false
    private var nextCursor = BehaviorRelay(value: "")
    private let lastPage = PublishSubject<String>()
    
    func transform(input: Input) -> Output {
        let showResetAlert = PublishSubject<Void>()
        let resetMessage = PublishSubject<String>()
        var data: [PostModelToWrite] = []
        var query = GetPostQuery(next: "", limit: "6", product_id: "")
        let list = PublishSubject<[PostModelToWrite]>()
        //MARK: - 내가 한 질문
        
        input.myQuestionTap
            .subscribe(with: self, onNext: { owner, _ in
                PostNetworkManager.shared.networking(api: .viewPost(query: query), model: PostModelToView.self) { result in
                    switch result {
                    case .success(let success):
                        print(success)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        
        
        //MARK: - 탈퇴하기
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
        
        return Output(showResetAlert: showResetAlert, resetMessage: resetMessage, logoutTap: input.logoutTap)
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


extension SettingVM {
    
    func nextCursorChange(cursor: String?) {
        guard let cursor = cursor else { return }
        
        if cursor != "0" {
            nextCursor.accept(cursor)
            isLastPage = false
        } else {
            isLastPage = true
            lastPage.onNext("마지막 페이지입니다.")
        }
        
    }
    
}
