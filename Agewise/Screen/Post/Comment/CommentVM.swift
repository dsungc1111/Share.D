//
//  CommentVM.swift
//  Agewise
//
//  Created by 최대성 on 8/28/24.
//

import Foundation
import RxSwift
import RxCocoa


final class CommentVM {
  
    struct Input {
        let trigger: Observable<PostModelToWrite>
        let comment: ControlProperty<String>
        let uploadButtonTap: ControlEvent<Void>
        let deleteTap: ControlEvent<IndexPath>
    }
    struct Output {
        let commentList: BehaviorSubject<[CommentModel]>
        let errorMessage: PublishSubject<String>
    }
    private let disposeBag = DisposeBag()
    
    private let errorMessage = PublishSubject<String>()
    private var postId = ""
    private var comment = ""
    
    func transform(input: Input) -> Output {
        
        let commentList = BehaviorSubject(value: [CommentModel]())
        
        let trigger = BehaviorSubject(value: [CommentModel(comment_id: "", content: "", createdAt: "", creator: Creator(userId: "", nick: "", profileImage: nil))])
        
        var data: [CommentModel] = []
        
        input.trigger
            .subscribe(with: self, onNext: { owner, result in
                print(result)
                data = result.comments ?? []
                trigger.onNext(data)
                owner.postId = result.postID
                
            })
            .disposed(by: disposeBag)
        
        trigger
            .subscribe(with: self) { owner, value in
                commentList.onNext(value)
            }
            .disposed(by: disposeBag)
        
        input.comment
            .bind(with: self) { owner, value in
                owner.comment = value
            }
            .disposed(by: disposeBag)
        
        
        input.uploadButtonTap
            .map { [weak self] _ in
                let query = CommentQuery(content: self?.comment ?? "")
                return query
            }
            .subscribe(with: self) { owner, value in
                
                PostNetworkManager.shared.networking(api: .uploadComment(owner.postId, value), model: CommentModel.self) { result in
                    
                    switch result {
                    case .success(let success):
                        data.insert(success.1, at: 0)
                        trigger.onNext(data)
                       
                        NotificationCenter.default.post(name: NSNotification.Name("commentCount"), object: data.count)
                        
                        
                        print(success)
                    case .failure(let error):
                        if error == .expierdRefreshToken {
                            owner.errorMessage.onNext("만료됨")
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.deleteTap
            .bind(with: self) { owner, indexPath in
                let commentId = data[indexPath.row].comment_id
                
                if  data[indexPath.row].creator.userId == UserDefaultManager.userId {
                    PostNetworkManager.shared.networking(api: .deleteComment(owner.postId, commentId), model: CommentModel.self) { result in
                        switch result {
                        case .success(_):
                            
                            data.remove(at: indexPath.row)
                            
                            trigger.onNext(data)
                            
                        case .failure(let error):
                            if error == .expierdRefreshToken {
                                owner.errorMessage.onNext("만료됨")
                            }
                        }
                        data.remove(at: indexPath.row)
                        trigger.onNext(data)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(commentList: commentList, errorMessage: errorMessage)
    }
}
