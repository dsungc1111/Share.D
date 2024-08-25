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
    }
    struct Output {
        let detailInfo: PublishSubject<PostModelToWrite>
    }
    
    private let disposeBag = DisposeBag()
    
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
        
        
        return Output(detailInfo: detailInfo)
    }
    
    
}
