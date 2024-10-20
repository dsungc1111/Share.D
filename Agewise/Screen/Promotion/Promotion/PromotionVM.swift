//
//  PromoteViewModel.swift
//  Agewise
//
//  Created by 최대성 on 8/16/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PromotionVM: BaseViewModel {
    
    enum CategoryTitle: String, CaseIterable {
        
        case ipad
        case food
        case clothes
        case beauty
        case travel
        case candle
        case starbucks
        case holi
    }
    
    
    
    struct Input {
        let adTrigger: Observable<Void>
//        let trendTap: ControlEvent<String>
//        let ageButtonTap: ControlEvent<Void>
//        let timer: Observable<Int>
//        let currentIndex: ControlEvent<[IndexPath]>
    }
    
    struct Output {
        let adList: PublishSubject<[ProductDetail]>
        let categoryList: PublishSubject<[String]>

        let logout: PublishSubject<String>
        let profileImage: PublishSubject<String>
    }
    private var currentIndex: Int = 0
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let adList = PublishSubject<[ProductDetail]>()
        let categoryList = PublishSubject<[String]>()
//        let scrollIndexPath = PublishSubject<IndexPath>()
        let logout = PublishSubject<String>()
        let profileImage = PublishSubject<String>()
        //MARK: - About Token
        
        input.adTrigger
            .flatMap {
                TokenNetworkManager.shared.tokenNetwork(api: .fetchProfile, model: ProfileModel.self)
            }
            .bind(with: self) { owner, result in
                
                if let result = result.data {
                    profileImage.onNext(result.profileImage)
                }
                
                let present = CategoryTitle.allCases.map { $0.rawValue }
                
                categoryList.onNext(present)
                
            }
            .disposed(by: disposeBag)
        
        
        input.adTrigger
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { "집들이 선물" }
            .flatMap { value in
                NetworkManager.shared.naverAPI(query: value, start: 1)
            }
            .bind(with: self) { owner, result in
                
                switch result {
                case .success(let value):
                    let topTenItems = Array(value.items.prefix(6))
                    adList.onNext(topTenItems)
                case .failure(_):
                    print("네이버 실패")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(adList: adList, categoryList: categoryList, logout: logout, profileImage: profileImage)
    }
    
}
