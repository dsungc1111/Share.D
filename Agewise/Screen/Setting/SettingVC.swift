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
                
                owner.withdrawUser { 
                    
                    withdrawButtonTap.onNext(())
                    
                }
            }
            .disposed(by: disposeBag)
        
        output.resetMessage
            .bind(with: self) { owner, value in
                
              print(value)
             
            }
            .disposed(by: disposeBag)
        
        settingView.logoutButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.withdrawUser {
                    print("로그아웃")
                }
            }
            .disposed(by: disposeBag)
        
        
        settingView.editButton.rx.tap
            .bind(with: self) { owner, _ in
                print("클릭")
            }
            .disposed(by: disposeBag)
        
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "설정"
    }
}
