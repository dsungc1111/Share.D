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
    
    enum AgeTitle: String, CaseIterable {
        case teen = "10대"
        case graduation = "20대"
        case developer = "30대"
        case parent = "40대"
        case parent50 = "50대"
        case grand = "60대+"
    }
    
    enum productTitle: String, CaseIterable {
        case kid = "Kids"
        case cafe = "Man"
        case present = "Woman"
        case birth = "Parent"
        
    }
    
    struct Input {
        let adTrigger: Observable<Void>
        let trendTap: ControlEvent<String>
//        let ageButtonTap: ControlEvent<Void>
//        let timer: Observable<Int>
//        let currentIndex: ControlEvent<[IndexPath]>
    }
    
    struct Output {
        let adList: PublishSubject<[ProductDetail]>
        let presentList: PublishSubject<[String]>
        let trendTap: ControlEvent<String>
//        let scrollIndexPath: PublishSubject<IndexPath>
        let logout: PublishSubject<String>
        let profileImage: PublishSubject<String>
    }
    private var currentIndex: Int = 0
    private let disposeBag = DisposeBag()
    
    
    func transform(input: Input) -> Output {
        
        let adList = PublishSubject<[ProductDetail]>()
        let presentList = PublishSubject<[String]>()
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
                
            }
            .disposed(by: disposeBag)
        
        
        input.adTrigger
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { "요즘 인기 선물" }
            .flatMap { value in
                NetworkManager.shared.naverAPI(query: value, start: 1)
            }
            .bind(with: self) { owner, result in
                
                switch result {
                case .success(let value):
                    adList.onNext(value.items)
                case .failure(_):
                    print("네이버 실패")
                }
                
                let present = productTitle.allCases.map { $0.rawValue }
                
                presentList.onNext(present)
                
            }
            .disposed(by: disposeBag)
        
        return Output(adList: adList, presentList: presentList, trendTap: input.trendTap, logout: logout, profileImage: profileImage)
    }
    
}
