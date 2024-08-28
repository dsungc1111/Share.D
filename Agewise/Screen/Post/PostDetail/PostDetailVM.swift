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
//        let detectChange: Observable<Void>
    }
    struct Output {
        let detailInfo: PublishSubject<PostModelToWrite>
        let likeTap: ControlEvent<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    
    
    private var postId = ""
    private var userLike = false
    
    func transform(input: Input) -> Output {
        
        let detailInfo = PublishSubject<PostModelToWrite>()
        let trigger = BehaviorSubject<String>(value: "")
        
        input.trigger
            .subscribe(with: self, onNext: { owner, result in
                print(result)
                trigger.onNext(result)
                
            })
            .disposed(by: disposeBag)
        
        
        trigger
            .flatMap { value in
                NetworkManager.shared.detailPost(query: value)
            }
            .subscribe(with: self) { owner, result in
               
                switch result {
                case .success(let value):
                    owner.postId = value.postID
                    detailInfo.onNext(value)
                    
                    if let like = value.likes {
                        if like.contains(UserDefaultManager.shared.userId) {
                            owner.userLike = true
                        }
                    }
                    
                case .failure(_):
                    print("실패")
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
                    case .success(let success):
                        trigger.onNext(owner.postId)
                    case .failure(let failure):
                        print(failure)
                    }
                }
                
            }
            .disposed(by: disposeBag)
        
        return Output(detailInfo: detailInfo, likeTap: input.likeTap)
    }
}
