//
//  ListCategoryCollectionViewCell.swift
//  Agewise
//
//  Created by 최대성 on 8/21/24.
//

import UIKit
import SnapKit

final class ListCategoryCollectionViewCell: BaseCollectionViewCell {
    
    private let categoryButton = {
        let btn = UIButton()
        btn.titleLabel?.textAlignment = .center
        btn.isEnabled = false
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 30
        btn.clipsToBounds = true
        return btn
    }()
    
    override func configureLayout() {
        
        contentView.addSubview(categoryButton)
        
        categoryButton.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView.safeAreaLayoutGuide).inset(5)
            make.size.equalTo(60)
        }
    }

   
    func configureCell(element: String) {
        categoryButton.setTitle(element, for: .normal)
    }
}
