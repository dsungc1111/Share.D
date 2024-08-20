//
//  QuestionListViewModel.swift
//  Agewise
//
//  Created by 최대성 on 8/20/24.
//

import Foundation
import RxSwift
import RxCocoa

final class QuestionListViewModel: BaseViewModel {
    
    enum AgeTitle: String, CaseIterable {
        case teen = "10대"
        case graduation = "20대"
        case developer = "30대"
        case parent = "40대"
        case parent50 = "50대"
        case grand = "60대+"
    }
    
    struct Input {
        let trigger: Observable<Void>
        let categoryTap: ControlEvent<String>
    }
    
    struct Output {
        let list: PublishSubject<[PostModelToWrite]>
        let ageList: PublishSubject<[String]>
    }
    private let disposeBag = DisposeBag()
    
    override init() {
        NetworkManager.shared.fetchProfile()
    }
    
    func transform(input: Input) -> Output {
        
        // test용 쿼리
        var query = GetPostQuery(next: "", limit: "10", product_id: "10대선물용")
        let list = PublishSubject<[PostModelToWrite]>()
        let ageList = PublishSubject<[String]>()
        
        input.trigger
            .flatMap { NetworkManager.shared.getPost(query: query) }
            .subscribe(with: self) { owner, result in
                
                switch result {
                    
                case .success(let value):
                    list.onNext(value.data)
                case .failure(_):
                    print("실패")
                }
                let age = AgeTitle.allCases.map { $0.rawValue }
                
                
                ageList.onNext(age)
                
            }
            .disposed(by: disposeBag)
        
        input.categoryTap
            .map { text in
                GetPostQuery(next: "", limit: "10", product_id: text + "선물용")
            }
            .flatMap { value in
                NetworkManager.shared.getPost(query: value)
            }
            .subscribe(with: self) { owner, result in
                
                switch result {
                    
                case .success(let value):
                    list.onNext(value.data)
                case .failure(_):
                    print("실패")
                }
                
            }
            .disposed(by: disposeBag)
     
        return Output(list: list, ageList: ageList)
    }
}
