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
    
    private let settingDetailView = SettingDetailView()
    
    var list: [PostModelToWrite]?
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = settingDetailView
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        let initailList = list ?? []
        let newList = BehaviorSubject(value: initailList)
        
        
        newList
            .bind(to: settingDetailView.collectionView.rx.items(cellIdentifier: SettingDetailCollectionViewCell.identifier, cellType: SettingDetailCollectionViewCell.self)) { (item, element, cell) in
                
                print("실행")
                cell.configureCell(element: element)
                
            }
            .disposed(by: disposeBag)
        
    }
    
    
}
