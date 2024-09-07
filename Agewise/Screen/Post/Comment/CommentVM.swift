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
    private var indexPath: IndexPath?
    private var commentOn = false
    
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
            .flatMap { [weak self] query in
                PostNetworkManager.shared.postNetwork(api: .uploadComment(self?.postId ?? "", query), model: CommentModel.self)
            }
            .subscribe(with: self) { owner, result in
                
                if let result = result.data {
                    data.insert(result, at: 0)
                    trigger.onNext(data)
                }
                if result.statusCode == 418 {
                    owner.errorMessage.onNext("만료됨")
                }
                
                NotificationCenter.default.post(name: NSNotification.Name("commentCount"), object: data.count)
            
            }
            .disposed(by: disposeBag)
        
        input.deleteTap
            .map { [weak self] indexPath in
                let commentId = data[indexPath.row].comment_id
                self?.indexPath = indexPath
                return commentId
            }
            .filter { [weak self] _ in
                if data[self?.indexPath?.row ?? 0].creator.userId == UserDefaultManager.userId {
                    return true
                } else {
                    return false
                }
            }
            .flatMap { [weak self] commentId in
                PostNetworkManager.shared.postNetwork(api: .deleteComment(self?.postId ?? "", commentId), model: CommentModel.self)
            }
            .bind(with: self) { owner, result in
                
                data.remove(at: owner.indexPath?.row ?? 0)
                
                trigger.onNext(data)
                
            }
            .disposed(by: disposeBag)
        
        return Output(commentList: commentList, errorMessage: errorMessage)
    }
}
