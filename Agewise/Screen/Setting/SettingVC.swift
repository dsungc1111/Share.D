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
    
    private let settingVM = SettingVM()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let withdrawButtonTap = PublishSubject<Void>()
        
        let input = SettingVM.Input(resetTap: settingView.resetbutton.rx.tap, withdrawButtonTap: withdrawButtonTap)
        
        let output = settingVM.transform(input: input)
        
        output.showResetAlert
            .bind(with: self) { owner, _ in
                owner.withdrawUser { result in
                    if result == "확인" {
                        withdrawButtonTap.onNext(())
                    }
                }
            }
            .disposed(by: disposeBag)
        output.resetMessage
            .bind(with: self) { owner, value in
                
              print(value)
             
            }
            .disposed(by: disposeBag)
        
//        settingView.logoutButton.rx.tap
//            .bind(with: self) { owner, _ in
//                owner.withdrawUser(title: "로그아웃!!", content: "로그아웃?")
//            }
//            .disposed(by: disposeBag)
        
    }
}
