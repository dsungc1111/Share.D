//
//  SettingVC.swift
//  Agewise
//
//  Created by 최대성 on 8/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingVC: BaseVC {
    
    private let settingView = SettingView()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        settingView.resetbutton.rx.tap
            .bind(with: self) { owner, _ in
                NetworkManager.shared.withdraw(vc: self) 
            }
            .disposed(by: disposeBag)
        
        
    }
    
}
