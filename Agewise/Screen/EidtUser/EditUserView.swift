//
//  EditUserView.swift
//  Agewise
//
//  Created by 최대성 on 9/1/24.
//

import UIKit
import SnapKit

final class EditUserView: BaseView {
    
    let photoPicker = {
        let btn = UIButton()
        btn.setTitle("프로필 수정", for: .normal)
        btn.backgroundColor = .systemGreen
        return btn
    }()
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person.circle")
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()
    let nicknameTextField = LoginTextField(placeholderText: UserDefaultManager.shared.userNickname)
    
    let editButton = {
        let btn = UIButton()
        btn.setTitle("수정하기", for: .normal)
        btn.backgroundColor = .systemRed
        return btn
        
    }()
    
    
    override func configureHierarchy() {
        addSubview(photoPicker)
        addSubview(imageView)
        addSubview(nicknameTextField)
        addSubview(editButton)
    }
    
    override func configureLayout() {
        photoPicker.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(30)
            make.leading.equalTo(safeAreaLayoutGuide).inset(50)
            make.size.equalTo(100)
        }
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(photoPicker.snp.trailing).offset(20)
            make.top.equalTo(safeAreaLayoutGuide).inset(30)
            make.size.equalTo(100)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(photoPicker.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.equalTo(40)
        }
        editButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.equalTo(40)
        }
        
    }
    
    
}
