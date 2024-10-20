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
    
    private let postListViewModel = PostListVM()
    
    private let disposeBag = DisposeBag()
    
    private var showToast: (() -> Void)?
    
    override func loadView() {
        view = postListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func configureNavigationBar() {
//        postListView.searchController.searchResultsUpdater = self
//        postListView.searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.title = "커뮤니티"
//        postListView.searchController.searchBar.placeholder = "Search"
//        
//        navigationItem.searchController = postListView.searchController
        
        definesPresentationContext = true
    }
   
    override func bind() {
        
        let loadMoreTrigger = PublishSubject<Void>()
                
        postListView.resultCollectionView.rx.prefetchItems
            .bind(with: self, onNext: { owner, indexPaths in
                
                guard let lastVisibleIndexPath = owner.postListView.resultCollectionView.indexPathsForVisibleItems.last else { return }
                if lastVisibleIndexPath.item >= owner.postListView.resultCollectionView.numberOfItems(inSection: 0) - 2 {
                    loadMoreTrigger.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        
        let input = PostListVM.Input(segmentIndex: postListView.genderSegmentedControl.rx.selectedSegmentIndex, loadMore: loadMoreTrigger)
        
        let output = postListViewModel.transform(input: input)
 
        
        
        // 결과 컬렉션뷰
        output.productList
            .bind(to: postListView.resultCollectionView.rx.items(cellIdentifier: PostListCollectionViewCell.identifier, cellType: PostListCollectionViewCell.self)) { (item, element, cell) in
                
                cell.configureCell(element: element)
                
            }
            .disposed(by: disposeBag)
        
        // 결과 선택
        postListView.resultCollectionView.rx.modelSelected(PostModelToWrite.self)
            .bind(with: self) { owner, result in
                let vc = PostDetailVC()
                vc.element = result.postID
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
      
                
        // 피커뷰 생성 코드
//        output.ageList
//            .bind(to: postListView.agePickerView.rx.itemTitles) { (row, element) in
//                return element
//            }
//            .disposed(by: disposeBag)
        
        // 페이지네이션 방지
//        output.lastPage
//            .bind(with: self) { owner, result in
//                owner.view.makeToast(result, duration: 2.0, position: .bottom)
//            }
//            .disposed(by: disposeBag)
        
        
        output.errorMessage
            .bind(with: self) { owner, value in
                owner.logoutUser()
            }
            .disposed(by: disposeBag)
    }
}
