//
//  SettingDetailCollectionViewCell.swift
//  Agewise
//
//  Created by 최대성 on 8/28/24.
//

import UIKit
import RxSwift
import SnapKit
import Kingfisher


final class SettingDetailCollectionViewCell: BaseCollectionViewCell {
    
    private let dateTool = ReuseDateformatter.shared
    
    private let imageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.contentMode = .scaleToFill
        return image
    }()
    private let writerLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    private let dateLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 11)
        label.textColor = .lightGray
        return label
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
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.tintColor = UIColor(hexCode: MainColor.main.rawValue, alpha: 1)
        btn.setTitleColor(UIColor(hexCode: MainColor.main.rawValue, alpha: 1), for: .normal)
        return btn
    }()
    let checkBox = {
       let btn = UIButton()
        btn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        btn.isHidden = true
        return btn
    }()
    var disposeBag = DisposeBag()

       
    override func prepareForReuse() {
        imageView.image = nil
        companyNameLabel.text = nil
        productNameLabel.text = nil
        priceLabel.text = nil
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(writerLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(companyNameLabel)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(checkBox)
    }
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(220)
        }
        writerLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(writerLabel.snp.bottom).offset(5)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        companyNameLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(5)
            make.height.equalTo(20)
        }
        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(companyNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(5)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(5)
        }
        likeButton.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).inset(5)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        checkBox.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(3)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.size.equalTo(30)
        }
        
    }
    
    func configureCell(element: PostModelToWrite) {
        
        let date = Date()
        let image = element.files?.first ?? ""
        let imageURL = URL(string: image)
        imageView.kf.setImage(with: imageURL)
        
        priceLabel.text = element.price?.formatted() ?? "0" + "원"
        productNameLabel.text = element.title.removeHtmlTag
        
        writerLabel.text = element.creator.nick
        dateLabel.text = dateTool.messageTime(dateString: element.createdAt, currentDate: date)
        
        
        companyNameLabel.text = element.content1
        
        if let likeCount = element.likes?.count {
            likeButton.setTitle(likeCount.formatted(), for: .normal)
            
            for i in 0..<likeCount {
                if UserDefaultManager.shared.userId == element.likes?[i] {
                    likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    break
                }
            }
        }
    }
    func toggleCheckBox(isVisible: Bool) {
            checkBox.isHidden = !isVisible
        }
    
}
