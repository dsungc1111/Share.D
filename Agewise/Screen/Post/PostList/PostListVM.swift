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
  
    struct Input {
        let listTrigger: Observable<Void>
        let loadMore: PublishSubject<Void>
    }
    
    struct Output {
        let productList: PublishSubject<[PostModelToWrite]>
//        let lastPage: PublishSubject<String>
        let errorMessage: PublishSubject<String>
    }
    
    private let disposeBag = DisposeBag()
    
    private var isLastPage = false
    private var nextCursor = BehaviorRelay(value: "")
    private let lastPage = PublishSubject<String>()
    private let errorMessage = PublishSubject<String>()
    
    
    func transform(input: Input) -> Output {
        
        
        let list = PublishSubject<[PostModelToWrite]>()
        
        
        var data: [PostModelToWrite] = []
        let query = GetPostQuery(next: "", limit: "5", product_id: "선물용")
        
        
        input.listTrigger
            .flatMap {
                PostNetworkManager.shared.postNetwork(api: .getPost(query: query), model: PostModelToView.self)
            }
            .bind(with: self, onNext: { owner, result in
                if let searchResult = result.data {
                    data = []
                    data.append(contentsOf: searchResult.data)
                    list.onNext(data)
                    owner.nextCursorChange(cursor: searchResult.next_cursor)
                }
            })
            .disposed(by: disposeBag)

        
        input.loadMore
            .filter { [weak self] _ in
                self?.isLastPage == false
            }
            .map { [weak self] _ in
                GetPostQuery(next: self?.nextCursor.value ?? "", limit: "5", product_id: query.product_id)
            }
            .flatMap { query in
                PostNetworkManager.shared.postNetwork(api: .getPost(query: query), model: PostModelToView.self)
            }
            .subscribe(with: self) { owner, result in
                if let searchResult = result.data {
                    data.append(contentsOf: searchResult.data)
                    list.onNext(data)
                    owner.nextCursorChange(cursor: searchResult.next_cursor)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(productList: list, errorMessage: errorMessage)
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
        }
    }
}
