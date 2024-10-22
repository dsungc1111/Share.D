//
//  QuestionListTableViewCell.swift
//  Agewise
//
//  Created by 최대성 on 8/20/24.
//

import UIKit
import SnapKit

final class PostListCollectionViewCell: BaseCollectionViewCell {

    
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
    let writerLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    let titleLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    let priceLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.clipsToBounds = true
        return label
    }()
    let contentLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.numberOfLines = 5
        return label
    }()
    let commentButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        btn.tintColor = .black
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    let likeButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.tintColor = .black
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
   
    override func configureHierarchy() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(writerLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(commentButton)
        contentView.addSubview(likeButton)
    }
    override func configureLayout() {
        contentView.layer.cornerRadius = 10
        
        imageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.width.equalTo(160)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        writerLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.width.equalTo(200)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(writerLabel.snp.bottom).offset(10)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(30)
        }
        commentButton.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        likeButton.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.leading.equalTo(commentButton.snp.trailing).offset(10)
        }
        priceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.leading.equalTo(likeButton.snp.trailing).offset(10)
        }
    }

    func configureCell(element: PostModelToWrite) {
        
        let date = Date()
        
        dateLabel.text = dateTool.messageTime(dateString: element.createdAt, currentDate: date)
        writerLabel.text = "게시자 : \(element.creator.nick)"
        priceLabel.text = "₩ " + (element.price?.formatted() ?? "0")
        titleLabel.text = element.title.removeHtmlTag
        if let image = element.files?.first {
            let imageUrl = URL(string: image)
            imageView.kf.setImage(with: imageUrl)
        }
        contentLabel.text = element.content
        
        let commentCount = element.comments?.count ?? 0
        commentButton.setTitle(commentCount.formatted(), for: .normal)
        
        let likes = element.likes?.count ?? 0
        likeButton.setTitle(likes.formatted(), for: .normal)
        
        
        
        
    }
}
