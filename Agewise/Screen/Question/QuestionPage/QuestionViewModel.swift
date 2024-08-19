//
//  QuestionViewModel.swift
//  Agewise
//
//  Created by 최대성 on 8/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class QuestionViewModel: BaseViewModel {
    
    
    struct Input {
        let saveTap: ControlEvent<Void>
        let question: ControlProperty<String>
        let category: Observable<String>
        let productInfo: Observable<ProductDetail>
    }
    struct Output {
        let result: Observable<Bool>
    }
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        
       let result = input.question
            .map { $0.count != 0 }
        
        
        let combined = Observable.combineLatest(input.productInfo, input.question, input.category)
        
        input.saveTap
            .withLatestFrom(combined)
            .bind(with: self) { owner, result in
                
                let product = result.0
                let text = result.1
                let category = result.2
                
                
                let save = PostQuery(title: product.title, content: text, content1: product.lprice, content2: product.mallName, content3: product.productId, product_id: category + "선물용" , files: [product.image])
                NetworkManager.shared.writePost(query: save)
                
            }
            .disposed(by: disposeBag)
        
        return Output(result: result)
    }
}
