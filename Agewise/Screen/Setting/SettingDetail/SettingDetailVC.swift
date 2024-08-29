//
//  SettingDetailVC.swift
//  Agewise
//
//  Created by 최대성 on 8/27/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingDetailVC: BaseVC {
    
    deinit {
        print("settingDetailVC deinit")
    }
    
    private let settingDetailView = SettingDetailView()
    
    private let settingDetailVM = SettingDetailVM()
    
    var list: [PostModelToWrite]?
    
    var navigationTitle = ""
    
    var checkbox = false
    
    
    var rightBarButton = UIBarButtonItem(title: "선택", style: .plain, target: nil, action: nil)
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = settingDetailView
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func configureNavigationBar() {
        
        navigationItem.title = navigationTitle
        navigationItem.rightBarButtonItem = rightBarButton
        
        if navigationTitle == "좋아요" {
            navigationItem.rightBarButtonItem = nil
        }
        
    }
    
    override func bind() {
        
        let initailList = list ?? []
        
        
        let input = SettingDetailVM.Input(list: Observable.just(initailList), selectTap: rightBarButton.rx.tap)
        
        let output = settingDetailVM.transform(input: input)
        
        output.list
            .bind(to: settingDetailView.collectionView.rx.items(cellIdentifier: SettingDetailCollectionViewCell.identifier, cellType: SettingDetailCollectionViewCell.self)) { (item, element, cell) in
  
                cell.configureCell(element: element)
                
            }
            .disposed(by: disposeBag)
        
        output.rightTitle
            .bind(to: rightBarButton.rx.title)
            .disposed(by: disposeBag)
    }
    
    
}
