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
        
        case birthday = "생일"
        case food = "졸업식"
        case lux = "럭셔리"
        case test = "수능"
        case special = "기념일"
        case candle = "집들이"
        case starbucks = "교환권"
        case holi = "명절"
    }
    
    struct Input {
        let adTrigger: Observable<Void>
        let searchText: ControlProperty<String>
        let searchButtonTap: ControlEvent<Void>

    }
    
    struct Output {
        let adList: PublishSubject<[ProductDetail]>
        let categoryList: PublishSubject<[String]>
        let logout: PublishSubject<String>
        let profileImage: PublishSubject<String>
        let searchText: PublishSubject<String>
    }
    private var currentIndex: Int = 0
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let adList = PublishSubject<[ProductDetail]>()
        let categoryList = PublishSubject<[String]>()

        let logout = PublishSubject<String>()
        let profileImage = PublishSubject<String>()
        let searchText = PublishSubject<String>()
        
        
        
        input.adTrigger
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { "집들이 선물" }
            .flatMap { value in
                Single.zip(NetworkManager.shared.naverAPI(query: value, start: 1),
                           TokenNetworkManager.shared.tokenNetwork(api: .fetchProfile, model: ProfileModel.self)
                )
            }
            .bind(with: self) { owner, result in
                
                let present = CategoryTitle.allCases.map { $0.rawValue }
                categoryList.onNext(present)
                
                let (product, profile) = result
                
                if let result = profile.data {
                    profileImage.onNext(result.profileImage)
                }
                
                if profile.statuscode == 418 {
                    logout.onNext("로그인 만료")
                }
                
                
                switch product {
                case .success(let value):
                    let topTenItems = Array(value.items.prefix(6))
                    adList.onNext(topTenItems)
                case .failure(_):
                    print("네이버 실패")
                }
               
            }
            .disposed(by: disposeBag)
      
        
        input.searchButtonTap
            .withLatestFrom(input.searchText)
            .bind(with: self) { owner, text in
                searchText.onNext(text)
            }
            .disposed(by: disposeBag)
            
        
        
        return Output(adList: adList, categoryList: categoryList, logout: logout, profileImage: profileImage, searchText: searchText)
    }
    
}
