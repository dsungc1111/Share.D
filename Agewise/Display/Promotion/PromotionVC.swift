//
//  MainVC.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PromotionVC: BaseVC {

    private let promotionView = PromotionView()
    
    private let disposeBag = DisposeBag()
    
    let data = [1,2,3,4,4,5]
    
    override func loadView() {
        view = promotionView
    }
    
    //ForP
    override func viewDidLoad() {
        super.viewDidLoad()
        print("mainVC임!!")
        
        promotionView.categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        
        let aa = Observable.just(data)
        
        
        aa
            .bind(to: promotionView.categoryCollectionView.rx.items(cellIdentifier: CategoryCollectionViewCell.identifier, cellType: CategoryCollectionViewCell.self)) { (row, element, cell) in
                
                
                
            }
            .disposed(by: disposeBag)
        
    }
}
