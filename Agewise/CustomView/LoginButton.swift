//
//  LoginButton.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import UIKit

final class LoginButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        layer.cornerRadius = 10
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        setTitleColor(UIColor(hexCode: MainColor.main.rawValue, alpha: 1), for: .normal)
        layer.borderWidth = 1
        layer.borderColor = UIColor(hexCode: MainColor.main.rawValue, alpha: 1).cgColor
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
