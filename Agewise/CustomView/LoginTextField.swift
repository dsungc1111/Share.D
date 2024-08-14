//
//  LoginTextField.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import UIKit

class LoginTextField: UITextField {
    
    
    init(placeholderText: String) {
        super.init(frame: .zero)
        placeholder = placeholderText
        layer.cornerRadius = 10
        layer.borderWidth = 1
        leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        leftViewMode = .always
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
