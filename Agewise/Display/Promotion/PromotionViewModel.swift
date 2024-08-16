//
//  PromoteViewModel.swift
//  Agewise
//
//  Created by 최대성 on 8/16/24.
//

import Foundation
import RxSwift

final class PromotionViewModel {
    
    
    struct Input {
        let adTrigger: Observable<Void>
    }
    
    struct Output {
        let adList: PublishSubject<[ProductDetail]>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        print(#function)
        
        
        let adList = PublishSubject<[ProductDetail]>()
        
        
        
        input.adTrigger
            .map { "핫딜" }
            .flatMap { value in
                NetworkManager.shared.naverAPI(query: value)
            }
            .subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let value):
                    adList.onNext(value.items)
                case .failure(_):
                    print("실패")
                }
                
            }
            .disposed(by: disposeBag)
        
       
        return Output(adList: adList)
        
    }
    
}
