//
//  MainVC.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher


final class PromotionVC: BaseVC {

    
    enum CategoryTitle: String, CaseIterable {
        case teen = "10대"
        case graduation = "20대"
        case developer = "30대"
        case parent = "40대"
        case l = "50대"
        case grand = "60대+"
    }
    private let promotionView = PromotionView()
    
    private let promotionViewModel = PromotionViewModel()
    
    private let disposeBag = DisposeBag()
    
    let temp = [1,2,3,4,5,6,7,8,9]
    
    override func loadView() {
        view = promotionView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let data = CategoryTitle.allCases.map { $0.rawValue }
        
        let aa = Observable.just(data)
        
        
        
        let input = PromotionViewModel.Input(adTrigger: Observable.just(()))
        
        
        let output = promotionViewModel.transform(input: input)
        
        
        
        output.adList
            .bind(to: promotionView.adCollectionView.rx.items(cellIdentifier: AdCollectionViewCell.identifier, cellType: AdCollectionViewCell.self)) {
                (item, element, cell) in
                
                let image = URL(string: element.image)
                cell.productImage.kf.setImage(with: image)
                
            }
            .disposed(by: disposeBag)
        
        aa
            .bind(to: promotionView.categoryCollectionView.rx.items(cellIdentifier: CategoryCollectionViewCell.identifier, cellType: CategoryCollectionViewCell.self)) { (item, element, cell) in
                
                cell.cellConfiguration(item: item)
                
                cell.button.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.promotionView.stateLabel.text = element
                    }
                    .disposed(by: cell.disposeBag)
                
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
