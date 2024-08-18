//
//  ProductViewModel.swift
//  Agewise
//
//  Created by 최대성 on 8/17/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProductViewModel {
    
    struct Input {
        let searchItem: Observable<String>
        let loadMore: Observable<Void>
    }
    
    struct Output {
        let searchList: PublishSubject<[ProductDetail]>
    }
    
    private let disposeBag = DisposeBag()
    
    private var data: [ProductDetail] = []
    var page = BehaviorRelay<Int>(value: 1)
    
    func transform(input: Input) -> Output {
        
        let list = PublishSubject<[ProductDetail]>()
        
        let searchWithPage = Observable.combineLatest(input.searchItem, page.asObservable())
        
        searchWithPage
            .flatMapLatest { query, page in
                
                NetworkManager.shared.naverAPI(query: query, page: page)
            }
            .subscribe(with: self, onNext: { owner, result in
                switch result {
                case .success(let value):
                    print(owner.page.value)
                    if owner.page.value == 1 {
                        owner.data = value.items
                    } else {
                        owner.data.append(contentsOf: value.items)
                    }
                    list.onNext(owner.data)
                case .failure(let error):
                    print("에러: \(error)")
                }
            })
            .disposed(by: disposeBag)
        
        
//        input.loadMore
//            .subscribe(with: self, onNext: { owner, _ in
//                owner.page.accept(owner.page.value + 1)
//            })
//            .disposed(by: disposeBag)
        
        
        return Output(searchList: list)
    }
    
}
