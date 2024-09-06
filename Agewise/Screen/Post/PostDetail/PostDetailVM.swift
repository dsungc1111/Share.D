//
//  DetailPostVM.swift
//  Agewise
//
//  Created by 최대성 on 8/22/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailPostVM {
    
    
    deinit {
        print("=======deinit")
    }
    
    struct Input {
        let trigger: Observable<String>
        let likeTap: ControlEvent<Void>
    }
    struct Output {
        let detailInfo: PublishSubject<PostModelToWrite>
        let likeTap: ControlEvent<Void>
        let errorMessage: PublishSubject<String>
    }
    
    private let disposeBag = DisposeBag()
    private let delete = BehaviorSubject(value: "")
    private var postId = ""
    private var userLike = false
    let trigger = BehaviorSubject<String>(value: "")
    private let errorMessage = PublishSubject<String>()
    
    
    func transform(input: Input) -> Output {
        
        let detailInfo = PublishSubject<PostModelToWrite>()
        
        
        input.trigger
            .subscribe(with: self, onNext: { owner, result in
                print(result)
                owner.trigger.onNext(result)
            })
            .disposed(by: disposeBag)
        
        
        trigger
            .subscribe(with: self) { owner, value in
               
                PostNetworkManager.shared.networking(api: .detailPost(query: value), model: PostModelToWrite.self) { result in
                    switch result {
                    case .success(let value):
                        owner.postId = value.1.postID
                        detailInfo.onNext(value.1)
                        
                        if let like = value.1.likes {
                            if like.contains(UserDefaultManager.userId) {
                                owner.userLike = true
                            }
                        }
                    case .failure(let error):
                        if error == .expierdRefreshToken {
                            owner.errorMessage.onNext("만료됨")
                        }
                    }
                }
                
                
                
            }
            .disposed(by: disposeBag)
             
        input.likeTap
            .map { [weak self] _ in
                self?.userLike.toggle()
                let like = LikeQuery(like_status: self?.userLike ?? true)
                return like
            }
            .subscribe(with: self) { owner, value in
                
                PostNetworkManager.shared.networking(api: .likePost(owner.postId, value), model: LikeModel.self) { result in
                    
                    switch result {
                    case .success(_):
                        owner.trigger.onNext(owner.postId)
                    case .failure(let error):
                        if error == .expierdRefreshToken {
                            owner.errorMessage.onNext("만료됨")
                        }
                    }
                }
                
            }
            .disposed(by: disposeBag)
        
        return Output(detailInfo: detailInfo, likeTap: input.likeTap, errorMessage: errorMessage)
    }
}
