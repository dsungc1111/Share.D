//
//  QuestionListVC.swift
//  Agewise
//
//  Created by 최대성 on 8/15/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class PostListVC: BaseVC {
    
    private let postListView = PostListView()
    
    private let postListViewModel = PostListViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var showToast: (() -> Void)?
    
    override func loadView() {
        view = postListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: nil)
  
    }
    override func bind() {
        
        let loadMoreTrigger = PublishSubject<Void>()
        
        postListView.resultCollectionView.rx.prefetchItems
            .bind(with: self, onNext: { owner, indexPaths in
                guard let lastIndexPath = indexPaths.last else { return }
                
                if lastIndexPath.item >= owner.postListView.resultCollectionView.numberOfItems(inSection: 0) - 1 {
                    loadMoreTrigger.onNext(())
                }
            })
               .disposed(by: disposeBag)
        
        
        let input = PostListViewModel.Input(trigger: Observable.just(()), categoryTap: postListView.categoryCollectionView.rx.modelSelected(String.self), loadMore: loadMoreTrigger)
        
        let output = postListViewModel.transform(input: input)
        
        
        postListView.resultCollectionView.rx.modelSelected(PostModelToWrite.self)
            .bind(with: self) { owner, result in
                let vc = PostDetailVC()
                vc.element = result.postID
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 나이대 선택 컬렉션뷰
        output.ageList
            .bind(to: postListView.categoryCollectionView.rx.items(cellIdentifier: ListCategoryCollectionViewCell.identifier, cellType: ListCategoryCollectionViewCell.self)) { item, element, cell in
                
                cell.categoryButton.setTitle(element, for: .normal)
            }
            .disposed(by: disposeBag)
        
        
        // 결과 컬렉션뷰
        output.productList
            .bind(to: postListView.resultCollectionView.rx.items(cellIdentifier: PostListCollectionViewCell.identifier, cellType: PostListCollectionViewCell.self)) { (item, element, cell) in
                
                cell.configureCell(element: element)
                
            }
            .disposed(by: disposeBag)
        // 페이지네이션 방지
        output.lastPage
            .bind(with: self) { owner, result in
                owner.view.makeToast(result, duration: 2.0, position: .bottom)
            }
            .disposed(by: disposeBag)
    }
}
