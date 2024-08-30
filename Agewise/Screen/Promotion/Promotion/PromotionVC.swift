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
    
    private let promotionViewModel = PromotionVM()
    
    private let disposeBag = DisposeBag()
    
    private var showToast: (() -> Void)?
    
    override func loadView() {
        view = promotionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func configureNavigationBar() {
        
        let title = "Hello, \(UserDefaultManager.shared.userNickname) 님 "

        let barButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        let profile = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItems = [profile, barButtonItem]
    }
    
    override func bind() {
        
//        let timer = Observable<Int>.interval(.seconds(4), scheduler: MainScheduler.instance)
        
        
        let input = PromotionVM.Input(adTrigger: Observable.just(()), trendTap: promotionView.recommendCollectionView.rx.modelSelected(String.self))
        
        
        let output = promotionViewModel.transform(input: input)
        
        
        output.trendTap
            .bind(with: self) { owner, popular in
                let vc = ProductVC()
                vc.navigationItem.title = "For " + popular
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
            .bind(to: promotionView.recommendCollectionView.rx.items(cellIdentifier: RecommendCollectionViewCell.identifier, cellType: RecommendCollectionViewCell.self)) { (item, element, cell) in
                
                let image = ["kids","Man", "Woman", "Parent"]
                
                cell.configureCell(element: element, image: UIImage(named: image[item]))
                
            }
            .disposed(by: disposeBag)
        
        
        
        
        
//        promotionView.searchButton.rx.tap
//            .bind(with: self) { owner, _ in
//                
//                let age = owner.promotionView.ageButton.titleLabel?.text
//                let gender = owner.promotionView.genderButton.titleLabel?.text
//                let searchText = (age ?? "") + " " + (gender ?? "")
//                
//                if age == "연령대" || gender == "성별" {
//                    owner.view.makeToast("조건을 선택해주세요!!", duration: 2.0, position: .center)
//                } else {
//                    let vc = ProductVC()
//                    vc.searchItem = searchText
//                    vc.navigationItem.title = "For " + searchText
//                    owner.navigationController?.pushViewController(vc, animated: true)
//                }
//            }
//            .disposed(by: disposeBag)
        
//        output.scrollIndexPath
//            .bind(with: self, onNext: { owner, indexPath in
//                owner.promotionView.adCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//            })
//            .disposed(by: disposeBag)
        
        
        output.logout
            .bind(with: self) { owner, result in
                owner.logoutUser()
                print(result)
            }
            .disposed(by: disposeBag)
        
    }
    
  
    
    
}
