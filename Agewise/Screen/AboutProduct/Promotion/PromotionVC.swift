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
            .bind(with: self) { owner, category in
                let vc = ProductVC()
                vc.searchItem = category
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.trendTap
            .bind(with: self) { owner, popular in
                let vc = ProductVC()
                vc.searchItem = popular
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        
        //MARK: - 광고 배너
        output.adList
            .bind(to: promotionView.adCollectionView.rx.items(cellIdentifier: AdCollectionViewCell.identifier, cellType: AdCollectionViewCell.self)) {
                (item, element, cell) in
                
                cell.configureCell(element: element)
                
            }
            .disposed(by: disposeBag)
        
        //MARK: - 연령별 버튼
        output.ageList
            .bind(to: promotionView.categoryCollectionView.rx.items(cellIdentifier: CategoryCollectionViewCell.identifier, cellType: CategoryCollectionViewCell.self)) { (item, element, cell) in
                
                cell.cellConfiguration(item: item)
            }
            .disposed(by: disposeBag)
        
        //MARK: - 추천
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
