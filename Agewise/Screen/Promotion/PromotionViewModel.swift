//
//  PromoteViewModel.swift
//  Agewise
//
//  Created by 최대성 on 8/16/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PromotionViewModel {
    
    enum AgeTitle: String, CaseIterable {
        case teen = "10대"
        case graduation = "20대"
        case developer = "30대"
        case parent = "40대"
        case l = "50대"
        case grand = "60대+"
    }
    
    enum productTitle: String, CaseIterable {
        case cafe = "카페교환권"
        case present = "선물세트"
        case birth = "생일선물"
        case luxury = "명품선물"
    }
    
    struct Input {
        let adTrigger: Observable<Void>
        let categoryTap: ControlEvent<String>
        let trendTap: ControlEvent<String>
    }
    
    struct Output {
        let adList: PublishSubject<[ProductDetail]>
        let ageList: PublishSubject<[String]>
        let presentList: PublishSubject<[String]>
        let categoryTap: ControlEvent<String>
        let trendTap: ControlEvent<String>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let adList = PublishSubject<[ProductDetail]>()
        let ageList = PublishSubject<[String]>()
        let presentList = PublishSubject<[String]>()
        
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
                
                let age = AgeTitle.allCases.map { $0.rawValue }
                let present = productTitle.allCases.map { $0.rawValue }
                
                ageList.onNext(age)
                presentList.onNext(present)
                
            }
            .disposed(by: disposeBag)
        
        
        return Output(adList: adList, ageList: ageList, presentList: presentList, categoryTap: input.categoryTap, trendTap: input.trendTap)
    }
    
}
