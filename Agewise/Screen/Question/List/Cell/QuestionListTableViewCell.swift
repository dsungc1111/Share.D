//
//  QuestionListTableViewCell.swift
//  Agewise
//
//  Created by 최대성 on 8/20/24.
//

import UIKit
import SnapKit

final class QuestionListCollectionViewCell : BaseCollectionViewCell {

    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    // 상품제목
    let titleLabel = {
        let label = UILabel()
        label.text = "예비"
        label.font = .boldSystemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    let priceLabel = {
        let label = UILabel()
        label.text = "예비"
        label.font = .systemFont(ofSize: 11)
        return label
    }()
   
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
    }
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.size.equalTo(70)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.width.equalTo(200)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
    }

}
