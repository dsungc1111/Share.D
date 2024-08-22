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
        
        return Output(detailInfo: detailInfo)
    }
    
    
}
