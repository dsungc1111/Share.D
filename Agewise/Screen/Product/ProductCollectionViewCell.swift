//
//  ProductCollectionViewCell.swift
//  Agewise
//
//  Created by 최대성 on 8/17/24.
//

import UIKit
import SnapKit
import Kingfisher

final class ProductCollectionViewCell: BaseCollectionViewCell {
    
   
    let imageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.contentMode = .scaleToFill
        return image
    }()
    let companyNameLabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    let productNameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 2
        return label
    }()
    let priceLabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    let likeButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 10
        button.setImage(UIImage(systemName: "heart.circle"), for: .normal)
        return button
    }()
    
    override func prepareForReuse() {
        imageView.image = nil
        companyNameLabel.text = nil
        productNameLabel.text = nil
        priceLabel.text = nil
    }
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(companyNameLabel)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeButton)
    }
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(100)
        }
        companyNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(5)
            make.height.equalTo(20)
        }
        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(companyNameLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(5)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(5)
        }
        likeButton.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).inset(10)
            make.trailing.equalTo(imageView.snp.trailing).inset(10)
            make.size.equalTo(40)
        }
    }
   
    func configureCell(element: ProductDetail) {
        
        priceLabel.text = (Int(element.lprice)?.formatted() ?? "0") + "원"
        productNameLabel.text = element.title.removeHtmlTag
        priceLabel.text = Int(element.lprice)?.formatted()
        
        let image = URL(string: element.image)
        
        imageView.kf.setImage(with: image)
        
    }
    
}
