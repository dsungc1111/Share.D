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
    
    let temp = [1,2,3,4,5,6,7,8,9]
    
    override func loadView() {
        view = promotionView
    }
    
    //ForP
    override func viewDidLoad() {
        super.viewDidLoad()
        print("mainVC임!!")
        
        
        let aa = Observable.just(data)
        
        
        aa
            .bind(to: promotionView.categoryCollectionView.rx.items(cellIdentifier: CategoryCollectionViewCell.identifier, cellType: CategoryCollectionViewCell.self)) { (item, element, cell) in
                
                cell.cellConfiguration(item: item)
            }
            .disposed(by: disposeBag)
        
        let tempp = Observable.just(temp)
        
        tempp
            .bind(to: promotionView.trendCollectionView.rx.items(cellIdentifier: TrendCollectionViewCell.identifier, cellType: TrendCollectionViewCell.self)) { (row, element, cell) in
                
                print(element)
                cell.label.text = "df"
                
            }
            .disposed(by: disposeBag)
    }
}
