//
//  CategoryCellVeiwModel.swift
//  Agewise
//
//  Created by 최대성 on 8/17/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CategoryCellVeiwModel: UICollectionViewCell {
 
    
    
    
    struct Input {
        let itemTap: ControlEvent<Void>
        let searchWord: Observable<String>
    }
    
    struct Output {
        let aa: String
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output{
        
        input.itemTap
            .withLatestFrom(input.searchWord)
            .flatMap { 
                value in
                NetworkManager.shared.naverAPI(query: value + "선물")
            }
            .bind(with: self) { owner, result in
                print(result)
            }
            .disposed(by: disposeBag)
        
        return Output(aa: "dfdfd")
    }
}
