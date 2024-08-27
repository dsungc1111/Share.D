//
//  SettingView.swift
//  Agewise
//
//  Created by 최대성 on 8/19/24.
//

import UIKit
import SnapKit

final class SettingView: BaseView {
    
    
    let profileView = {
        let view = UIView()
        return view
    }()
    let profileImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 50
        view.image = UIImage(systemName: "person.circle")
        view.contentMode = .scaleToFill
        return view
    }()
    let nicknameLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "닉네임   \(UserDefaultManager.shared.userNickname)"
        return label
    }()
    let elseInfoLabel = {
        let label = UILabel()
        label.text = " ♡ 20 팔로우 20 팔로잉 20  "
        return label
    }()
    let editButton = {
        let btn = UIButton()
        btn.layer.borderWidth = 0.5
        return btn
    }()
    let myQuestionButton = SettingButton(title: "내가 한 질문", image: "questionmark.app")
    
    let myLikeButton = SettingButton(title: "좋아요", image: "heart.square")
    
    let resetbutton = SettingButton(title: "탈퇴하기", image: "rectangle.portrait.and.arrow.right")
    
    let logoutButton = SettingButton(title: "로그아웃", image: "hand.raised.app")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(profileView)
        addSubview(profileImageView)
        addSubview(nicknameLabel)
        addSubview(elseInfoLabel)
        addSubview(editButton)
        
        addSubview(myQuestionButton)
        addSubview(myLikeButton)
        addSubview(resetbutton)
        addSubview(logoutButton)
        
    }
    
    override func configureLayout() {
        
        profileView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.size.equalTo(100)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(45)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        elseInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(20)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        editButton.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        editButton.backgroundColor = .clear
        
        
        myQuestionButton.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        
        myLikeButton.snp.makeConstraints { make in
            make.top.equalTo(myQuestionButton.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(myLikeButton.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        
        
        resetbutton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
    }
}
