//
//  SignUpView.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import UIKit
import SnapKit

final class SignUpView: BaseView {
    
    
    let emailTextField = LoginTextField(placeholderText: " 이메일을 입력하세요.")
    let emailWarningLabel = UILabel()
    
    let passwordTextField = LoginTextField(placeholderText: "비밀번호를 입력하세요.")
    let passwordWarningLabel = UILabel()
    
    let nicknameTextField = LoginTextField(placeholderText: "닉네임을 입력하세요.")
    let nicknameWarningLabel = UILabel()
    
    let signUpButton = LoginButton(title: "회원가입")
    
    override func configureHierarchy() {
        
        addSubview(emailTextField)
        addSubview(emailWarningLabel)
        addSubview(passwordTextField)
        addSubview(passwordWarningLabel)
        addSubview(nicknameTextField)
        addSubview(nicknameWarningLabel)
        addSubview(signUpButton)
    }
    override func configureLayout() {
        
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(250)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        emailWarningLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.equalTo(20)
        }
        emailWarningLabel.backgroundColor = .systemBlue
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailWarningLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        passwordWarningLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.equalTo(20)
        }
        passwordWarningLabel.backgroundColor = .systemBlue
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordWarningLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        nicknameWarningLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.equalTo(20)
        }
        nicknameWarningLabel.backgroundColor = .systemBlue
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameWarningLabel.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.equalTo(40)
        }
    }
    
}