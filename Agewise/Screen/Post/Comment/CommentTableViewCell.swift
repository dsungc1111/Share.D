//
//  CommentTableViewCell.swift
//  Agewise
//
//  Created by 최대성 on 8/28/24.
//

import UIKit
import SnapKit

final class CommentTableViewCell: BaseTableViewCell {

    
    private let dateTool = ReuseDateformatter.shared
    
    let profileImage = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person.circle")
        
        return view
    }()
    let usernameLabel = {
        let label = UILabel()
        label.text = "유저이름"
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()
    let contentLabel = {
        let label = UILabel()
        label.text = "컨텐트 자리"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    let dateLabel = {
        let label = UILabel()
        label.text = "날짜 자리"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
 
    override func configureHierarchy() {
        contentView.addSubview(profileImage)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateLabel)
    }
    
    override func configureLayout() {
        
        profileImage.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.size.equalTo(40)
        }
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(25)
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(15)
        }
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(25)
            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
            make.height.equalTo(15)
        }
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            
        }
        
    }
    
    func configureCell(element: CommentModel) {
        let date = Date()
        usernameLabel.text = element.creator.nick
        contentLabel.text = element.content
        dateLabel.text = dateTool.messageTime(dateString: element.createdAt, currentDate: date)
        
        
    }

}
