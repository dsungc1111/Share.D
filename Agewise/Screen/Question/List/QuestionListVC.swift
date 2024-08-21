//
//  QuestionListVC.swift
//  Agewise
//
//  Created by 최대성 on 8/15/24.
//

import UIKit
import RxSwift
import RxCocoa

final class QuestionListVC: BaseVC {
    
    private let questionListView = QuestionListView()
    
    private let questionListViewModel = QuestionListViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = questionListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: nil)
  
    }
    override func bind() {
        
        let loadMoreTrigger = PublishSubject<Void>()
        
        questionListView.resultCollectionView.rx.prefetchItems
            .bind(with: self, onNext: { owner, indexPaths in
                guard let lastIndexPath = indexPaths.last else { return }
                
                if lastIndexPath.item >= owner.questionListView.resultCollectionView.numberOfItems(inSection: 0) - 1 {
                    print("이건됨?")
                    loadMoreTrigger.onNext(())
                }
            })
               .disposed(by: disposeBag)
        
        
        let input = QuestionListViewModel.Input(trigger: Observable.just(()), categoryTap: questionListView.categoryCollectionView.rx.modelSelected(String.self), loadMore: loadMoreTrigger)
        
        let output = questionListViewModel.transform(input: input)
        
        
        output.ageList
            .bind(to: questionListView.categoryCollectionView.rx.items(cellIdentifier: ListCategoryCollectionViewCell.identifier, cellType: ListCategoryCollectionViewCell.self)) { item, element, cell in
                
                cell.categoryButton.setTitle(element, for: .normal)
            }
            .disposed(by: disposeBag)
        
        output.productList
            .bind(to: questionListView.resultCollectionView.rx.items(cellIdentifier: QuestionListCollectionViewCell.identifier, cellType: QuestionListCollectionViewCell.self)) { (item, element, cell) in
                
                cell.configureCell(element: element)
                
            }
            .disposed(by: disposeBag)
        
        output.lastPage
            .bind(with: self) { owner, result in
                print(result)
            }
            .disposed(by: disposeBag)
    }
    
    
}
