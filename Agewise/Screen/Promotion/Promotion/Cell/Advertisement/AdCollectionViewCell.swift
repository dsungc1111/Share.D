//
//  AdCollectionViewCell.swift
//  Agewise
//
//  Created by 최대성 on 8/16/24.
//

import UIKit
import SnapKit
import Kingfisher

final class AdCollectionViewCell: BaseCollectionViewCell {
    
    
    private let productImage = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        return image
    }()
    private let mallLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .lightGray
        return label
    }()
    private let titleLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    private let priceLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(productImage)
        
        contentView.addSubview(mallLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
    }
    
    override func configureLayout() {
        productImage.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(180)
        }
        mallLabel.snp.makeConstraints { make in
            make.top.equalTo(productImage.snp.bottom).offset(5)
            make.leading.equalTo(contentView.safeAreaLayoutGuide)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallLabel.snp.bottom).offset(10)
            make.horizontalEdges.leading.equalTo(contentView.safeAreaLayoutGuide)
            
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        
    }
    
    func configureCell(element: ProductDetail, item: Int) {
        let image = URL(string: element.image)
        
        productImage.kf.setImage(with: image)
        
        mallLabel.text = element.mallName
        
        titleLabel.text = element.title.removeHtmlTag
        let price = Int(element.lprice)
        priceLabel.text = "₩ " + (price?.formatted() ?? "0")
    }
    
}
