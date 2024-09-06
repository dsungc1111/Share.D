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
            .flatMap { query in
                PostNetworkManager.shared.postNetwork(api: .detailPost(query: query), model: PostModelToWrite.self)
            }
            .bind(with: self) { owner, result in
                
                if let result = result.data {
                    owner.postId = result.postID
                    detailInfo.onNext(result)
                    if let like = result.likes {
                        if like.contains(UserDefaultManager.userId) {
                            owner.userLike = true
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
            .flatMap { [weak self] query in
                PostNetworkManager.shared.postNetwork(api: .likePost(self?.postId ?? "", query), model: LikeModel.self)
            }
            .bind(with: self) { owner, result in
                
                owner.trigger.onNext(owner.postId)
                
                if result.statusCode == 418 {
                    owner.errorMessage.onNext("만료됨")
                }
                
            }
            .disposed(by: disposeBag)
        
        return Output(detailInfo: detailInfo, likeTap: input.likeTap, errorMessage: errorMessage)
    }
}
