//
//  SettingView.swift
//  Agewise
//
//  Created by 최대성 on 8/19/24.
//

import UIKit
import SnapKit

final class SettingView: BaseView {
    
    
    let resetbutton = {
        let btn = UIButton()
        btn.setTitle("탈퇴하기", for: .normal)
        return btn
    }()
    let logoutButton = {
        let btn = UIButton()
        btn.setTitle("로그아웃", for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureLayout() {
        addSubview(resetbutton)
        addSubview(logoutButton)
        
        resetbutton.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(100)
        }
        resetbutton.backgroundColor = .systemCyan
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(resetbutton.snp.bottom).offset(10)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(100)
        }
        logoutButton.backgroundColor = .systemRed
    }
    
}
