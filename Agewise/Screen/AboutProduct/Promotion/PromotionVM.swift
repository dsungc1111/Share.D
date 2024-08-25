//
//  PromoteViewModel.swift
//  Agewise
//
//  Created by 최대성 on 8/16/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PromotionViewModel: BaseViewModel {
    
    enum AgeTitle: String, CaseIterable {
        case teen = "10대"
        case graduation = "20대"
        case developer = "30대"
        case parent = "40대"
        case parent50 = "50대"
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
        let trendTap: ControlEvent<String>
        let ageButtonTap: ControlEvent<Void>
        let timer: Observable<Int>
        let currentIndex: ControlEvent<[IndexPath]>
    }
    
    struct Output {
        let adList: PublishSubject<[ProductDetail]>
        let presentList: PublishSubject<[String]>
        let trendTap: ControlEvent<String>
        let scrollIndexPath: PublishSubject<IndexPath>
    }
    private var currentIndex: Int = 0
    private let disposeBag = DisposeBag()
    
    
    func transform(input: Input) -> Output {
        
        let adList = PublishSubject<[ProductDetail]>()
        let presentList = PublishSubject<[String]>()
        let scrollIndexPath = PublishSubject<IndexPath>()
        
        //MARK: - About Token
        
        input.adTrigger
            .subscribe(with: self) { owner, _ in
                TokenNetworkManager.shared.networking(api: .fetchProfile, model: ProfileModel.self) { result in
                    
                    switch result {
                    case .success((let statuscode, let value)):
                        print("스테이터스코드", statuscode)
                        print("밸류", value)
                        UserDefaultManager.shared.userNickname = value.nick
                        UserDefaultManager.shared.userId = value.id
                        print(UserDefaultManager.shared.userNickname)
                        
                    case .failure(_):
                        print("실팽ㅇㄹㅇㄹ")
                        
                        TokenNetworkManager.shared.networking(api: .refresh, model: RefreshModel.self) { result in
                            
                            print("리프레쉬 실행")
                            switch result {
                            case .success((let statuscode, let value)):
                                print("리프레쉬 토큰", statuscode)
                                
                                UserDefaultManager.shared.accessToken = value.accessToken
                                
                                TokenNetworkManager.shared.networking(api: .fetchProfile, model: ProfileModel.self) { result in
                                    
                                    switch result {
                                    case .success((let statuscode, let value)):
                                        print("성공")
                                    case .failure(_):
                                        print("실패")
                                    }
                                    
                                }
                            case .failure(_):
                                print("리프레쉬도 실패...?")
                            }
                            
                        }
                    }
                }
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
        
        input.timer
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .bind(with: self) { owner, result in
                print("11", owner.currentIndex)
                scrollIndexPath.onNext(IndexPath(item: (owner.currentIndex + 1) % 40, section: 0))
                owner.currentIndex += 1
                
            }
            .disposed(by: disposeBag)
        
        return Output(adList: adList, presentList: presentList, trendTap: input.trendTap, scrollIndexPath: scrollIndexPath)
    }
    
}
