//
//  QuestionListViewModel.swift
//  Agewise
//
//  Created by 최대성 on 8/20/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PostListVM: BaseViewModel {
    
    enum AgeTitle: String, CaseIterable {
        case teenWoman = "10대 여성"
        case teenMan = "10대 남성"
        case graduationWoman = "20대 여성"
        case graduationMan = "20대 남성"
        case developerWoman = "30대 여성"
        case developer = "30대 남성"
        case parentWoman = "40대 여성"
        case parent = "40대 남성"
        case parent50Woman = "50대 여성"
        case parent50 = "50대 남성"
        case grandWoman = "60대+ 여성"
        case grand = "60대+ 남성"
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
    private let lastPage = PublishSubject<String>()
    
    
    func transform(input: Input) -> Output {
        
        let ageList = PublishSubject<[String]>()
        let list = PublishSubject<[PostModelToWrite]>()
        
        let age = AgeTitle.allCases.map { $0.rawValue }
        var data: [PostModelToWrite] = []
        var query = GetPostQuery(next: "", limit: "6", product_id: "10대선물용")
        
        input.trigger
            .flatMap { NetworkManager.shared.getPost(query: query) }
        
            .subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let value):
                    data.append(contentsOf: value.data)
                    list.onNext(data)
                    owner.nextCursorChange(cursor: value.next_cursor ?? "")
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
                    owner.nextCursorChange(cursor: value.next_cursor ?? "")
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
                switch result {
                case .success(let value):
                    data.append(contentsOf: value.data)
                    list.onNext(data)
                    owner.nextCursorChange(cursor: value.next_cursor)
                case .failure(_):
                    print("실패")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(productList: list, ageList: ageList, lastPage: lastPage)
    }
}

extension PostListVM {
    
    func nextCursorChange(cursor: String?) {
        guard let cursor = cursor else { return }
        
        if cursor != "0" {
            nextCursor.accept(cursor)
            isLastPage = false
        } else {
            isLastPage = true
            lastPage.onNext("마지막 페이지입니다.")
        }
        
    }
    
}
