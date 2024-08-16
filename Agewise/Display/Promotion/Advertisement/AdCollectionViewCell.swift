//
//  AdCollectionViewCell.swift
//  Agewise
//
//  Created by 최대성 on 8/16/24.
//

import UIKit
import SnapKit

final class AdCollectionViewCell: UICollectionViewCell {
    
    let productImage = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func configureHierarchy() {
        contentView.addSubview(productImage)
    }
    
    func configureLayout() {
        productImage.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
}
