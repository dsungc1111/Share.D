//
//  SignInView.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import UIKit
import SnapKit


final class SignInView: BaseView {
    
    let emailTextField = LoginTextField(placeholderText: " 이메일을 입력하세요.")
    
    let passwordTextField = LoginTextField(placeholderText: "비밀번호를 입력하세요.")
  
    let signInButton = LoginButton(title: "로그인")
    
    override func configureHierarchy() {
        addSubview(emailTextField)
        
        addSubview(passwordTextField)
        
        addSubview(signInButton)
    }
    
    override func configureLayout() {
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(250)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.equalTo(40)
        }
    }
    
}
