//
//  OnBoardingView.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import UIKit
import SnapKit

final class OnBoardingView: BaseView {
    
    private let presnetImage = {
        let image = UIImageView()
        image.image = UIImage(named: "aa")
        return image
    }()
    private let titleLabel = {
        let label = UILabel()
        label.text = "Share.D"
        label.font = UIFont(name: "Copperplate", size: 40)
        label.textColor = UIColor(hexCode: MainColor.main.rawValue, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    let loginButton = LoginButton(title: "로그인")
    
    let signUpButton = LoginButton(title: "회원가입")
    
    override func configureHierarchy() {
        addSubview(presnetImage)
//        addSubview(titleLabel)
        addSubview(loginButton)
        addSubview(signUpButton)
    }
    override func configureLayout() {
        
        presnetImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(150)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            make.height.equalTo(200)
        }
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(presnetImage.snp.bottom).offset(30)
//            make.bottom.equalTo(loginButton.snp.top).offset(-30)
//            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
//        }
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(120)
            make.leading.equalTo(safeAreaLayoutGuide).inset(50)
            make.height.equalTo(60)
            make.width.equalTo(130)
        }
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(120)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(50)
            make.height.equalTo(60)
            make.width.equalTo(130)
        }
    }
    
    
}
