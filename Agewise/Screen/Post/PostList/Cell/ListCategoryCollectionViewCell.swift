//
//  ListCategoryCollectionViewCell.swift
//  Agewise
//
//  Created by 최대성 on 8/21/24.
//

import UIKit
import SnapKit

final class ListCategoryCollectionViewCell: BaseCollectionViewCell {
    
    let categoryButton = {
        let btn = UIButton()
        btn.titleLabel?.textAlignment = .center
        btn.isEnabled = false
        return btn
    }()
    
    
    override func configureLayout() {
        contentView.addSubview(categoryButton)
        
        categoryButton.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        categoryButton.backgroundColor = .red
    }
}
