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
    
    private let productViewModel = ProductViewModel()
    
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
        
        productView.collectionView.rx.prefetchItems
            .bind(with: self, onNext: { owner, indexPaths in
                guard let lastIndexPath = indexPaths.last else { return }
                if lastIndexPath.row >= self.productView.collectionView.numberOfItems(inSection: 0) - 1 {
                    loadMoreTrigger.onNext(())
                }
            })
               .disposed(by: disposeBag)
           
        let input = ProductViewModel.Input(searchItem: Observable.just(searchItem), loadMore: loadMoreTrigger)
      
        let output = productViewModel.transform(input: input)
        
        output.searchList
            .bind(to: productView.collectionView.rx.items(cellIdentifier: ProductCollectionViewCell.identifier, cellType: ProductCollectionViewCell.self)) { (row, element, cell) in
                
//                let vc = ProductDetailVC()
//                vc.product = element
                cell.configureCell(element: element)
//                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        let a = productView.collectionView.rx.modelSelected(ProductDetail.self)
        
        a.bind(with: self) { owner, result in
            let vc = ProductDetailVC()
            vc.product = result
            owner.navigationController?.pushViewController(vc, animated: true)
        }
        .disposed(by: disposeBag)
    }
    
    
}
