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
    }
    private var currentIndex: Int = 0
    private let disposeBag = DisposeBag()
    
    
    func transform(input: Input) -> Output {
        
        let adList = PublishSubject<[ProductDetail]>()
        let presentList = PublishSubject<[String]>()
//        let scrollIndexPath = PublishSubject<IndexPath>()
        let logout = PublishSubject<String>()
        //MARK: - About Token
        
        input.adTrigger
            .flatMap {
                TokenNetworkManager.shared.tokenNetwork(api: .fetchProfile, model: ProfileModel.self)
            }
            .subscribe(with: self) { owner, result in

//                print("데이터",result.data)
                print("스테이터스 코드", result.statuscode)
            }
            .disposed(by: disposeBag)
        
        
        input.adTrigger
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { "요즘 인기 선물" }
            .flatMap { value in
                NetworkManager.shared.naverAPI(query: value, page: 1)
            }
            .subscribe(with: self) { owner, result in
                
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
        
        
        //        input.currentIndex
        //            .bind(with: self, onNext: { owner, indexPath in
        //
        ////                owner.currentIndex = indexPath.item
        //
        //            })
        //            .disposed(by: disposeBag)
        
//        input.timer
//            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
//            .bind(with: self) { owner, result in
//                scrollIndexPath.onNext(IndexPath(item: (owner.currentIndex + 1) % 10, section: 0))
//                owner.currentIndex += 1
//                
//            }
//            .disposed(by: disposeBag)
        
        return Output(adList: adList, presentList: presentList, trendTap: input.trendTap, logout: logout)
    }
    
}
