//
//  ProductViewModel.swift
//  Agewise
//
//  Created by 최대성 on 8/17/24.
//

import Foundation
import RxSwift
//import RxCocoa

final class ProductViewModel {
    
    struct Input {
        let list: Observable<[ProductDetail]>
    }
    
    struct Output {
        let list: Observable<[ProductDetail]>
    }
    
    func transform(input: Input) -> Output {
        
        
        
        
        
        return Output(list: input.list)
    }
    
}
