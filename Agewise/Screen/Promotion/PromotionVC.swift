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

    private let promotionView = PromotionView()
    
    private let promotionViewModel = PromotionViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = promotionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let input = PromotionViewModel.Input(adTrigger: Observable.just(()), categoryTap: promotionView.categoryCollectionView.rx.modelSelected(String.self), trendTap: promotionView.trendCollectionView.rx.modelSelected(String.self))
        
        
        let output = promotionViewModel.transform(input: input)
        
        output.categoryTap
            .bind(with: self) { owner, result in
                let vc = ProductVC()
                vc.searchItem = result
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.trendTap
            .bind(with: self) { owner, result in
                let vc = ProductVC()
                vc.searchItem = result
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        
        output.adList
            .bind(to: promotionView.adCollectionView.rx.items(cellIdentifier: AdCollectionViewCell.identifier, cellType: AdCollectionViewCell.self)) {
                (item, element, cell) in
                
                let image = URL(string: element.image)
                cell.productImage.kf.setImage(with: image)
                
            }
            .disposed(by: disposeBag)
        
        output.ageList
            .bind(to: promotionView.categoryCollectionView.rx.items(cellIdentifier: CategoryCollectionViewCell.identifier, cellType: CategoryCollectionViewCell.self)) { (item, element, cell) in
                
                cell.cellConfiguration(item: item)
                
            }
            .disposed(by: disposeBag)
        
        
        output.presentList
            .bind(to: promotionView.trendCollectionView.rx.items(cellIdentifier: TrendCollectionViewCell.identifier, cellType: TrendCollectionViewCell.self)) { (row, element, cell) in
                
                cell.presentButton.setTitle(element, for: .normal)
                
            }
            .disposed(by: disposeBag)
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "AGEWISE"
    }
}
