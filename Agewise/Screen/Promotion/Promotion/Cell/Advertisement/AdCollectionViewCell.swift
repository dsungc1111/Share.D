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
    private let rankLabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(hexCode: MainColor.main.rawValue, alpha: 1)
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Copperplate-Bold", size: 25)
        
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        return label
    }()
    private let mallLabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    private let titleLabel = {
        let label = UILabel()
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
        contentView.addSubview(rankLabel)
        contentView.addSubview(mallLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
    }
    
    override func configureLayout() {
        productImage.snp.makeConstraints { make in
            make.horizontalEdges.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(5)
            make.height.equalTo(310)
        }
        rankLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(30)
            make.size.equalTo(40)
        }
        mallLabel.snp.makeConstraints { make in
            make.top.equalTo(productImage.snp.bottom).offset(5)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(30)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallLabel.snp.bottom).offset(10)
            make.horizontalEdges.leading.equalTo(contentView.safeAreaLayoutGuide).inset(30)
            
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(30)
        }
    }
    
    func configureCell(element: ProductDetail, item: Int) {
        let image = URL(string: element.image)
        productImage.kf.setImage(with: image)
        
        rankLabel.text = "\(item+1)"
        mallLabel.text = element.mallName
        
        titleLabel.text = element.title.removeHtmlTag
        let price = Int(element.lprice)
        priceLabel.text = "₩ " + (price?.formatted() ?? "0")
    }
    
}
