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
    
    
    let aa = ["3인분", "1인분", "2인분", "5ㄷ비눙"]
    
    struct Input {
        let trigger: Observable<PostModelToWrite>
        let comment: ControlProperty<String>
        let uploadButtonTap: ControlEvent<Void>
    }
    struct Output {
        let commentList: BehaviorSubject<[CommentModel]>
    }
    private let disposeBag = DisposeBag()
    
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
                    print("이거 실행?")
                    switch result {
                    case .success(let success):
                        data.insert(success.1, at: 0)
                        trigger.onNext(data)
                        print(success)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        
        
        return Output(commentList: commentList)
    }
}
