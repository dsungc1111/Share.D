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
        btn.backgroundColor = UIColor(hexCode: MainColor.main.rawValue, alpha: 1)
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    override func configureLayout() {
        
        contentView.addSubview(categoryButton)
        
        categoryButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func configureCell(element: String) {
        categoryButton.setTitle(element, for: .normal)
    }
}
