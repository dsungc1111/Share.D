//
//  QuestionListTableViewCell.swift
//  Agewise
//
//  Created by 최대성 on 8/20/24.
//

import UIKit
import SnapKit

final class PostListCollectionViewCell : BaseCollectionViewCell {

    
    private let dateTool = ReuseDateformatter.shared
    
    let dateLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 11)
        label.textColor = .lightGray
        return label
    }()
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    let titleLabel = {
        let label = UILabel()
        label.text = "예비"
        label.font = .boldSystemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    let priceLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.clipsToBounds = true
        return label
    }()
    let contentLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.numberOfLines = 2
        return label
    }()
   
    override func configureHierarchy() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(contentLabel)
    }
    override func configureLayout() {
        contentView.layer.cornerRadius = 10
        
        imageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.width.equalTo(120)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(35)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.width.equalTo(200)
        }
        priceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(25)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(30)
        }
    }

    func configureCell(element: PostModelToWrite) {
        
        let date = Date()
        
        dateLabel.text = dateTool.messageTime(dateString: element.createdAt, currentDate: date)
        
        priceLabel.text = (element.price?.formatted() ?? "0") + " 원"
        titleLabel.text = element.title.removeHtmlTag
        if let image = element.files?.first {
            let imageUrl = URL(string: image)
            imageView.kf.setImage(with: imageUrl)
        }
        contentLabel.text = element.content
        
//        element.creator.nick
        
        
    }
}
