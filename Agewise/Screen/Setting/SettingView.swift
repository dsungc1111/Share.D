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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureLayout() {
        addSubview(resetbutton)
        
        resetbutton.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(100)
        }
        resetbutton.backgroundColor = .systemCyan
    }
    
}
