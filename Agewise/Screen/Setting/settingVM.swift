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
        let myLikeTap: ControlEvent<Void>
        let logoutTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let withdrawButtonTap: PublishSubject<Void>
    }
    struct Output {
        let showResetAlert: PublishSubject<Void>
        let resetMessage: PublishSubject<String>
        let logoutTap: ControlEvent<Void>
        let list: PublishSubject<([PostModelToWrite],Bool)>
        let errorMessage: PublishSubject<String>
    }
    
    private let disposeBag = DisposeBag()
    private var isLastPage = false
    private var nextCursor = BehaviorRelay(value: "")
    private let lastPage = PublishSubject<String>()
    
    private let errorMessage = PublishSubject<String>()
    
    func transform(input: Input) -> Output {
        
        
        let showResetAlert = PublishSubject<Void>()
        let resetMessage = PublishSubject<String>()
        var data: [PostModelToWrite] = []
        let query = GetPostQuery(next: "", limit: "6", product_id: "")
        let list = PublishSubject<([PostModelToWrite], Bool)>()
        //MARK: - 내가 한 질문
        
        input.myQuestionTap
//            .flatMap {
//                NetworkManager.shared.viewPost(query: query)
//            }
            .flatMap { _ in
                PostNetworkManager.shared.postNetwork(api: .viewPost(query: query), model: PostModelToView.self)
            }
            .bind(with: self, onNext: { owner, result in
                data = []
                if let result = result.data {
                    data.append(contentsOf: result.data)
                    list.onNext((data, true))
                    owner.nextCursorChange(cursor: result.next_cursor ?? "")
                }
            })
            .disposed(by: disposeBag)
        
        
        //MARK: - 내가 좋아요한 목록
        
        input.myLikeTap
            .map {
                let query = LikePostQuery(next: "", limit: "")
                return query
            }
            .flatMap { query in
                PostNetworkManager.shared.postNetwork(api: .viewLikePost(query: query), model: PostModelToView.self)
            }
            .bind(with: self) { owner, result in
                data = []
                if let result = result.data {
                    data.append(contentsOf: result.data)
                    list.onNext((data, true))
                    owner.nextCursorChange(cursor: result.next_cursor ?? "")
                }
                
                if result.statusCode == 418 {
                    owner.errorMessage.onNext("만료됨")
                }
            }
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
            }
            .subscribe(with: self, onNext: { owner, result in
                
                let message = owner.judgeStatusCode(statusCode: result.statuscode, title: WithdrawKeyword.success.rawValue)
                
                resetMessage.onNext(message)
            })
            .disposed(by: disposeBag)
        
        
        return Output(showResetAlert: showResetAlert, resetMessage: resetMessage, logoutTap: input.logoutTap, list: list, errorMessage: errorMessage)
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
