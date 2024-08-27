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
    
    
    struct Input {
        let trigger: Observable<String>
        let deleteTap: ControlEvent<Void>
        let likeTap: ControlEvent<Void>
    }
    struct Output {
        let detailInfo: PublishSubject<PostModelToWrite>
    }
    
    private let disposeBag = DisposeBag()
    
    private var postId = ""
    private var userLike = false
    
    func transform(input: Input) -> Output {
        
        let detailInfo = PublishSubject<PostModelToWrite>()
        
        input.trigger
            .flatMap { value in
                NetworkManager.shared.detailPost(query: value)
            }
            .subscribe(with: self) { owner, result in
               
                switch result {
                case .success(let value):
                    print(value)
                    owner.postId = value.postID
                    print("owner.posterId", owner.postId)
                    detailInfo.onNext(value)
                case .failure(_):
                    print("실패")
                }
            }
            .disposed(by: disposeBag)
        
        
        input.deleteTap
            .withLatestFrom(detailInfo)
            .subscribe(with: self) { owner, result in
                
                let id = result.postID
                
                PostNetworkManager.shared.delete(api: .delete(query: id)) { result in
                    switch result {
                    case .success(let success):
                        print("삭제", success)
                    case .failure(let error):
                        print("에러 = ", error)
                    }
                }
            }
            .disposed(by: disposeBag)
        
//        let likeInfo = LikeQuery(postId: postId, like: false)
        
        
        input.likeTap
            .map { [weak self] _ in
                self?.userLike.toggle()
                let like = LikeQuery(like_status: self?.userLike ?? true)
                return like
            }
            .subscribe(with: self) { owner, value in
                
//                PostNetworkManager.shared.likePost(postId: self.postId, likeStatus: value) { code in
//                    print(code)
//                }
                
                PostNetworkManager.shared.networking(api: .likePost(owner.postId, value), model: LikeModel.self) { result in
                    
                    switch result {
                    case .success(let success):
                        print(success)
                    case .failure(let failure):
                        print(failure)
                    }
                }
                
            }
            .disposed(by: disposeBag)
        
        return Output(detailInfo: detailInfo)
    }
}
