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
        image.image = UIImage(named: "share")
        return image
    }()
    private let titleLabel = {
        let label = UILabel()
        label.text = "Share.D"
        label.font = UIFont(name: "Copperplate", size: 50)
        label.textColor = UIColor(hexCode: MainColor.main.rawValue, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private let centerPoint = {
        let point = UIView()
        
        return point
    }()
    
    let loginButton = LoginButton(title: "로그인")
    
    let signUpButton = LoginButton(title: "회원가입")
    
    override func configureHierarchy() {
        addSubview(presnetImage)
        addSubview(titleLabel)
        addSubview(centerPoint)
        addSubview(loginButton)
        addSubview(signUpButton)
    }
    override func configureLayout() {
        
        presnetImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(150)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(60)
            make.height.equalTo(260)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(presnetImage.snp.bottom).offset(30)
            make.bottom.equalTo(loginButton.snp.top).offset(-30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
        }
        centerPoint.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(120)
            make.size.equalTo(5)
        }

        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(120)
            make.leading.equalTo(safeAreaLayoutGuide).inset(50)
            make.height.equalTo(60)
            make.trailing.equalTo(centerPoint.snp.leading).offset(-10)
        }
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(120)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(50)
            make.height.equalTo(60)
            make.leading.equalTo(centerPoint.snp.trailing).offset(10)
        }
    }
    
    
}
