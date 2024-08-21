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
        let loadMore: PublishSubject<Void>
    }
    
    struct Output {
        let productList: PublishSubject<[PostModelToWrite]>
        let ageList: PublishSubject<[String]>
        let lastPage: PublishSubject<String>
    }
    
    private let disposeBag = DisposeBag()
    private var isLastPage = false
    private var nextCursor = BehaviorRelay(value: "")
    override init() {
        NetworkManager.shared.fetchProfile()
    }
    
    func transform(input: Input) -> Output {
        
        let list = PublishSubject<[PostModelToWrite]>()
        var data: [PostModelToWrite] = []
        let ageList = PublishSubject<[String]>()
        let lastPage = PublishSubject<String>()
        let age = AgeTitle.allCases.map { $0.rawValue }
        // 쿼리 초기세팅
        var query = GetPostQuery(next: "", limit: "6", product_id: "10대선물용")
        
        
        
        input.trigger
            .flatMap { NetworkManager.shared.getPost(query: query) }
            .subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let value):
                    data.append(contentsOf: value.data)
                    list.onNext(data)
                    
                    if value.next_cursor != "0" {
                        owner.nextCursor.accept(value.next_cursor)
                        print("페이지네이션했을 때 Nextcursor2 = ", owner.nextCursor.value)
                        owner.isLastPage = false
                    } else {
                        owner.isLastPage = true
                        lastPage.onNext("마지막 페이지입니다.")
                    }
                case .failure(_):
                    print("실패")
                }
                ageList.onNext(age)
                
            }
            .disposed(by: disposeBag)
        
        input.categoryTap
            .map { text in
                query.product_id = text + "선물용"
                return query
            }
            .flatMap { value in
                NetworkManager.shared.getPost(query: value)
            }
            .subscribe(with: self) { owner, result in
                data = []
                switch result {
                case .success(let value):
                    data.append(contentsOf: value.data)
                    list.onNext(data)
                    print("====================", data, "====================")
                    if value.next_cursor != "0" {
                        owner.nextCursor.accept(value.next_cursor)
                        print("첫 게시했을 때 Nextcursor = ", owner.nextCursor.value)
                        owner.isLastPage = false
                    } else {
                        owner.isLastPage = true
                        lastPage.onNext("마지막 페이지입니다.")
                    }
                case .failure(_):
                    print("실패")
                }
            }
            .disposed(by: disposeBag)
        
        input.loadMore
            .filter { [weak self] _ in
                self?.isLastPage == false
            }
            .map { [weak self] _ in
                GetPostQuery(next: self?.nextCursor.value ?? "", limit: "6", product_id: query.product_id)
            }
            .flatMap { value in
                NetworkManager.shared.getPost(query: value)
            }
            .subscribe(with: self) { owner, result in
                print("페이지네이션했을 때 Nextcursor1 = ", owner.nextCursor.value)
                switch result {
                case .success(let value):
                    
                    data.append(contentsOf: value.data)
                    list.onNext(data)
                    
                    if value.next_cursor != "0" {
                        owner.nextCursor.accept(value.next_cursor)
                        print("페이지네이션했을 때 Nextcursor2 = ", owner.nextCursor.value)
                        owner.isLastPage = false
                    } else {
                        owner.isLastPage = true
                        lastPage.onNext("마지막 페이지입니다.")
                    }
                case .failure(_):
                    print("실패")
                }
            }
            .disposed(by: disposeBag)
     
        return Output(productList: list, ageList: ageList, lastPage: lastPage)
    }
}
