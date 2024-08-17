//
//  CategoryCellVeiwModel.swift
//  Agewise
//
//  Created by 최대성 on 8/17/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CategoryCellVeiwModel {
    
    struct Input {
        let itemTap: ControlEvent<Void>
        let searchWord: Observable<String>
    }
    
    struct Output {
        let selectedList: PublishSubject<[ProductDetail]>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output{
    
        
        let selectedList = PublishSubject<[ProductDetail]>()
        
        input.itemTap
            .withLatestFrom(input.searchWord)
            .flatMap { 
                value in
                NetworkManager.shared.naverAPI(query: value + "선물")
            }
            .bind(with: self) { owner, result in
                print("진행")
                switch result {
                case .success(let value):
                    selectedList.onNext(value.items)
                case .failure(_):
                    print("실패")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(selectedList: selectedList)
    }
}
