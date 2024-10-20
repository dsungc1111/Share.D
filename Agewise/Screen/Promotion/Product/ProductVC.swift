//
//  ProductDetailVC.swift
//  Agewise
//
//  Created by 최대성 on 8/17/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ProductVC: BaseVC {

    private let productView = ProductView()
    
    private let productVM = ProductVM()
    
    private let disposeBag = DisposeBag()
    
    var searchItem = ""
    
    override func loadView() {
        view = productView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        let loadMoreTrigger = PublishSubject<Void>()
        
        // rx 사용했을 때 페이지네이션 UX 활용도 up
//        productView.collectionView.rx.prefetchItems
//            .bind(with: self, onNext: { owner, indexPaths in
//                
//                guard let lastVisibleIndexPath = owner.productView.collectionView.indexPathsForVisibleItems.last else { return }
//                print("lastVisibleIndexPath = ", lastVisibleIndexPath.item)
//                if lastVisibleIndexPath.item >= owner.productView.collectionView.numberOfItems(inSection: 0) - 4 {
//                    loadMoreTrigger.onNext(())
//                    
//                    
//                    print("아이템 넘버", owner.productView.collectionView.numberOfItems(inSection: 0))
//                }
//            })
//            .disposed(by: disposeBag)
        productView.collectionView.rx.contentOffset
            .map { [weak self] offset -> Bool in
                guard let self = self else { return false }
                let contentHeight = self.productView.collectionView.contentSize.height
                let frameHeight = self.productView.collectionView.frame.size.height
                let yOffset = offset.y
                let distanceToBottom = contentHeight - yOffset - frameHeight
                return distanceToBottom < 200
            }
            .distinctUntilChanged()
            .filter { $0 == true }  
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                loadMoreTrigger.onNext(())
            })
            .disposed(by: disposeBag)
           
        let input = ProductVM.Input(searchItem: Observable.just(searchItem), loadMore: loadMoreTrigger, searchDetail: productView.collectionView.rx.modelSelected(ProductDetail.self))
      
        let output = productVM.transform(input: input)
        
        output.searchList
            .bind(to: productView.collectionView.rx.items(cellIdentifier: ProductCollectionViewCell.identifier, cellType: ProductCollectionViewCell.self)) { (row, element, cell) in
   
                cell.configureCell(element: element)
            }
            .disposed(by: disposeBag)
        
        output.searchDetail
        .bind(with: self) { owner, result in
            let vc = ProductDetailVC()
            vc.product = result
            vc.category = owner.searchItem
            owner.navigationController?.pushViewController(vc, animated: true)
        }
        .disposed(by: disposeBag)
    }
    
    
}
