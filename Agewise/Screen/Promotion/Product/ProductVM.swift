//
//  ProductVM.swift
//  Agewise
//
//  Created by 최대성 on 8/17/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProductVM {
    
    struct Input {
        let searchItem: Observable<String>
        let loadMore: Observable<Void>
        let searchDetail: ControlEvent<ProductDetail>
    }
    
    struct Output {
        let searchList: PublishSubject<[ProductDetail]>
        let searchDetail: PublishSubject<ProductDetail>
    }
    
    private let disposeBag = DisposeBag()
    
    private var data: [ProductDetail] = []
    var start = BehaviorRelay<Int>(value: 1)
    
    func transform(input: Input) -> Output {
        
        let list = PublishSubject<[ProductDetail]>()
        let searchDetail = PublishSubject<ProductDetail>()
        
        let searchWithPage = Observable.combineLatest(input.searchItem, start.asObservable())
        
        
        
        searchWithPage
            .flatMapLatest { query, start in
                NetworkManager.shared.naverAPI(query: query, start: start)
            }
            .subscribe(with: self, onNext: { owner, result in
                switch result {
                case .success(let value):
                    print(owner.start.value)
                    if owner.start.value == 1 {
                        print("여기")
                        owner.data = value.items
                    } else {
                        owner.data.append(contentsOf: value.items)
                       print( value.items[0].title.removeHtmlTag)
                    }
                    list.onNext(owner.data)
                case .failure(let error):
                    print("에러: \(error)")
                }
            })
            .disposed(by: disposeBag)
        
        input.loadMore
            .subscribe(with: self, onNext: { owner, _ in
                let currentItemCount = owner.data.count
                owner.start.accept(currentItemCount + 1)
                print("새로운 start 값: \(owner.start.value)")
            })
            .disposed(by: disposeBag)
        
        input.searchDetail
            .bind(with: self) { owner, result in
                searchDetail.onNext(result)
            }
            .disposed(by: disposeBag)
            
        return Output(searchList: list, searchDetail: searchDetail)
    }
    
}
