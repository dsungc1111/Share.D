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
        
        print("서치아이템", searchItem)
        
        let loadMoreTrigger = PublishSubject<Void>()
        
        productView.collectionView.rx.prefetchItems
            .bind(with: self, onNext: { owner, indexPaths in
                //
                guard let lastIndexPath = indexPaths.last else { return }
                if lastIndexPath.row >= owner.productView.collectionView.numberOfItems(inSection: 0) - 1 {
                    loadMoreTrigger.onNext(())
                }
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
