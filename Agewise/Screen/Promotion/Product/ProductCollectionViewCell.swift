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
    
    
    private let imageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.contentMode = .scaleToFill
        return image
    }()
    private let companyNameLabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    private let productNameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 2
        return label
    }()
    private let priceLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    private let likeButton = {
        let btn = UIButton()
        btn.contentMode = .scaleAspectFill
        btn.layer.cornerRadius = 10
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.tintColor = UIColor(hexCode: MainColor.main.rawValue, alpha: 1)
        return btn
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
            make.top.equalTo(productNameLabel.snp.bottom).offset(2)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.size.equalTo(30)
        }
    }
    
    func configureCell(element: ProductDetail) {
        
        priceLabel.text = (Int(element.lprice)?.formatted() ?? "0") + "원"
        productNameLabel.text = element.title.removeHtmlTag
        priceLabel.text = Int(element.lprice)?.formatted()
        
        let image = URL(string: element.image)
        
        imageView.kf.setImage(with: image)
        
        companyNameLabel.text = element.mallName
        
    }
    
}
