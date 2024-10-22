//
//  BaseView.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import UIKit


class BaseView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {}
    func configureLayout() {}
    
    
}
