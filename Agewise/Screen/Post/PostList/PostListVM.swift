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
        case people10 = "10대"
        case people20 = "20대"
        case people30 = "30대"
        case people40 = "40대"
        case parent50 = "50대"
        case people60 = "60대+"
    }
    
    struct Input {
        let segmentIndex: ControlProperty<Int>
        let ageString: ControlEvent<[String]>
        let loadMore: PublishSubject<Void>
    }
    
    struct Output {
        let productList: PublishSubject<[PostModelToWrite]>
        let ageList: Observable<[String]>
        let lastPage: PublishSubject<String>
        let errorMessage: PublishSubject<String>
    }
    
    private let disposeBag = DisposeBag()
    
    private var isLastPage = false
    private var nextCursor = BehaviorRelay(value: "")
    private let lastPage = PublishSubject<String>()
    private var searchGenderText = ""
    private var searchAgeText = "10대"
    private let errorMessage = PublishSubject<String>()
    
    
    func transform(input: Input) -> Output {
        
        
        let list = PublishSubject<[PostModelToWrite]>()
        
        let age = AgeTitle.allCases.map { $0.rawValue }
        var data: [PostModelToWrite] = []
        var query = GetPostQuery(next: "", limit: "4", product_id: "10대Man 선물용")
        
        
        input.segmentIndex
            .map { [weak self] value in
                if value == 0 {
                    self?.searchGenderText = "Man"
                } else {
                    self?.searchGenderText = "Woman"
                }
                query.product_id = (self?.searchAgeText ?? "") + " " + (self?.searchGenderText ?? "") + "선물용"
                
                return query
            }
            .flatMap { query in
                PostNetworkManager.shared.postNetworkManager(api: .getPost(query: query), model: PostModelToView.self)
            }
            .bind(with: self, onNext: { owner, result in
                if let searchResult = result.data {
                    data = []
                    data.append(contentsOf: searchResult.data)
                    list.onNext(data)
                    owner.nextCursorChange(cursor: searchResult.next_cursor ?? "")
                }
            })
            .disposed(by: disposeBag)
        
        
        input.ageString
            .map { [weak self] age in
                self?.searchAgeText = age.first ?? ""
                query.product_id =  (self?.searchAgeText ?? "") + " " + (self?.searchGenderText ?? "") + "선물용"
                print(query)
                return query
            }
            .flatMap { query in
                PostNetworkManager.shared.postNetworkManager(api: .getPost(query: query), model: PostModelToView.self)
            }
            .bind(with: self, onNext: { owner, result in
                if let searchResult = result.data {
                    data = []
                    data.append(contentsOf: searchResult.data)
                    list.onNext(data)
                    owner.nextCursorChange(cursor: searchResult.next_cursor ?? "")
                }
            })
            .disposed(by: disposeBag)
        
        input.loadMore
            .filter { [weak self] _ in
                self?.isLastPage == false
            }
            .map { [weak self] _ in
                GetPostQuery(next: self?.nextCursor.value ?? "", limit: "10", product_id: query.product_id)
            }
            .flatMap { query in
                PostNetworkManager.shared.postNetworkManager(api: .getPost(query: query), model: PostModelToView.self)
            }
            .subscribe(with: self) { owner, result in
                if let searchResult = result.data {
                    data.append(contentsOf: searchResult.data)
                    list.onNext(data)
                    owner.nextCursorChange(cursor: searchResult.next_cursor ?? "")
                }
//                PostNetworkManager.shared.networking(api: .getPost(query: query), model: PostModelToView.self) { result in
//                    switch result {
//                    case .success(let value):
//                        let newData = value.1
//                        data.append(contentsOf: newData.data)
//                        list.onNext(data)
//                        owner.nextCursorChange(cursor: newData.next_cursor ?? "")
//                        print("성공리스트부분", newData.next_cursor ?? "쉽")
//                    case .failure(let failure):
//                        print("실패")
//                    }
//                }
//                switch result {
//                case .success(let value):
//                    data.append(contentsOf: value.data)
//                    list.onNext(data)
//                    owner.nextCursorChange(cursor: value.next_cursor)
//                case .failure(let error):
//                    if error == .expierdRefreshToken {
//                        owner.errorMessage.onNext("만료됨")
//                    }
//                }
            }
            .disposed(by: disposeBag)
        
        return Output(productList: list, ageList: Observable.just(age), lastPage: lastPage, errorMessage: errorMessage)
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
