//
//  ViewController.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import UIKit
import RxSwift
import RxCocoa


final class OnBoardingVC: BaseVC {

    private let onBoardingView = OnBoardingView()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = onBoardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onBoardingView.loginButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = SignInVC()
                vc.navigationItem.title = "로그인"
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        onBoardingView.signUpButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = SignUpVC()
                vc.navigationItem.title = "회원가입"
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    


}

