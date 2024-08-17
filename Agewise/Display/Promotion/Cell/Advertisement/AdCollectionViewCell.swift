//
//  AdCollectionViewCell.swift
//  Agewise
//
//  Created by 최대성 on 8/16/24.
//

import UIKit
import SnapKit

final class AdCollectionViewCell: BaseCollectionViewCell {
    
    let productImage = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()

    
    override func configureHierarchy() {
        contentView.addSubview(productImage)
    }
    
    override func configureLayout() {
        productImage.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
}
