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
        let trigger: Observable<String>
        let comment: ControlProperty<String>
        let uploadButtonTap: ControlEvent<Void>
    }
    struct Output {
        let b: BehaviorSubject<[String]>
    }
    private let disposeBag = DisposeBag()
    
    private var postId = ""
    
    func transform(input: Input) -> Output {
        
        let c = BehaviorSubject(value: [""])
        let comment = PublishSubject<String>()
        
        input.trigger
            .bind(with: self) { owner, value in
                print("동작")
                c.onNext(owner.aa)
                owner.postId = value
            }
            .disposed(by: disposeBag)
        
        c.bind(with: self) { owner, result in
            print("Dsfsdfdsfdsf", result)
        }
        .disposed(by: disposeBag)
        
        
        input.comment
            .bind(with: self) { owner, value in
                print(value)
                comment.onNext(value)
            }
            .disposed(by: disposeBag)
        
        
        input.uploadButtonTap
            .withLatestFrom(comment)
            .subscribe(with: self) { owner, value in
                
                print(owner.postId, value)
                
                PostNetworkManager.shared.networking(api: .uploadComment(owner.postId, value), model: commentModel.self) { result in
                    print("이거 실행?")
                    switch result {
                    case .success(let success):
                        print("성공성공성공성공성공성공성공성공")
                        print(success)
                    case .failure(let failure):
                        print(failure)
                        print("실패실패실패실패실패실패실패")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        
        
        return Output(b: c)
    }
}
