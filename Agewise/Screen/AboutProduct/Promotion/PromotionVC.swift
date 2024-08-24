//
//  MainVC.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast


final class PromotionVC: BaseVC {

    private let promotionView = PromotionView()
    
    private let promotionViewModel = PromotionViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var showToast: (() -> Void)?
    
    override func loadView() {
        view = promotionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        let timer = Observable<Int>.interval(.seconds(4), scheduler: MainScheduler.instance)
        
        
        
        let input = PromotionViewModel.Input(adTrigger: Observable.just(()), trendTap: promotionView.trendCollectionView.rx.modelSelected(String.self), ageButtonTap: promotionView.ageButton.rx.tap, timer: timer, currentIndex: promotionView.adCollectionView.rx.prefetchItems)
        
        
        let output = promotionViewModel.transform(input: input)
        
        
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
                
                cell.configureCell(element: element, item: item)
                
            }
            .disposed(by: disposeBag)
        
        
        
        //MARK: - 추천
        output.presentList
            .bind(to: promotionView.trendCollectionView.rx.items(cellIdentifier: TrendCollectionViewCell.identifier, cellType: TrendCollectionViewCell.self)) { (item, element, cell) in
                
                cell.presentButton.setTitle(element, for: .normal)
                
            }
            .disposed(by: disposeBag)
        
        
        
        
        promotionView.searchButton.rx.tap
            .bind(with: self) { owner, _ in
                
                let age = owner.promotionView.ageButton.titleLabel?.text
                let gender = owner.promotionView.genderButton.titleLabel?.text
                let searchText = (age ?? "나이") + (gender ?? "성별")
                
                if searchText == "연령대성별" {
                    owner.view.makeToast("조건을 선택해주세요!!", duration: 2.0, position: .center)
                } else {
                    let vc = ProductVC()
                    vc.searchItem = searchText
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        output.scrollIndexPath
            .bind(with: self, onNext: { owner, indexPath in
                owner.promotionView.adCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "AGEWISE"
    }
    
    
    
}
