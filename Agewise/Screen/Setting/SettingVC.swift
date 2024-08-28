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
        
        let input = SettingVM.Input(myQuestionTap: settingView.myQuestionButton.rx.tap, myLikeTap: settingView.myLikeButton.rx.tap, logoutTap: settingView.logoutButton.rx.tap, resetTap: settingView.resetbutton.rx.tap, withdrawButtonTap: withdrawButtonTap)
        
        let output = settingVM.transform(input: input)
        
        
        //MARK: - 프로필 설정
        settingView.editButton.rx.tap
            .bind(with: self) { owner, _ in
                print("클릭")
            }
            .disposed(by: disposeBag)
        
        
        //MARK: - 내가 한 질문, 좋아요
        output.list
            .subscribe(with: self) { owner, result in
                let vc = SettingDetailVC()
                vc.list = result
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        
        //MARK: - 로그아웃 버튼
        output.logoutTap
            .bind(with: self) { owner, _ in
                owner.withdrawUser(title: "로그아웃 ") {
                    print("로그아웃")
                }
            }
            .disposed(by: disposeBag)
        
        
        //MARK: - 탈퇴하기 버튼
        output.showResetAlert
            .bind(with: self) { owner, _ in
                
                owner.withdrawUser(title: "탈퇴 ") {
                    withdrawButtonTap.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        output.resetMessage
            .bind(with: self) { owner, value in
                
              print(value)
             
            }
            .disposed(by: disposeBag)
        
        
        output.list
            .bind(with: self) { owner, result in
                print(result)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "설정"
    }
}
