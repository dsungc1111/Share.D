//
//  PostDetailView.swift
//  Agewise
//
//  Created by 최대성 on 8/21/24.
//

import UIKit
import SnapKit
import Kingfisher

final class PostDetailView: BaseView {
    
    private let dateTool = ReuseDateformatter.shared
    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let contentLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    let writerLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    let dateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    let productLabel = {
        let label = UILabel()
        label.text = "제목 테이블 예비"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    let likeButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.tintColor = UIColor(hexCode: MainColor.main.rawValue, alpha: 1)
        return btn
    }()
    let bookmarkButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        btn.tintColor = UIColor(hexCode: MainColor.main.rawValue, alpha: 1)
        return btn
    }()
    let deleteButton = {
        let btn = UIButton()
        btn.setTitle("삭제", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.backgroundColor = .white
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.red.cgColor
        return btn
    }()
    
    override func configureHierarchy() {
        addSubview(imageView)
        addSubview(writerLabel)
        addSubview(dateLabel)
        addSubview(contentLabel)
        addSubview(productLabel)
        addSubview(likeButton)
        addSubview(bookmarkButton)
        addSubview(deleteButton)
    }
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(250)
        }
        writerLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(30)
        }
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(50)
            make.height.equalTo(30)
        }
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(30)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(200)
        }
        productLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.top).inset(10)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(productLabel.snp.bottom).inset(10)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        deleteButton.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
    }
    
    func configurePostDetail(element: PostModelToWrite) {
        
        guard let url = element.files?.first else { return }
        let image = URL(string: url)
        imageView.kf.setImage(with: image)
        
        writerLabel.text = "게시자 : " + element.creator.nick
        dateLabel.text = "게시일 : " + dateTool.changeStringForm(dateString: element.createdAt)
        contentLabel.text = element.content +  "  " + element.postID + "키키"
    }
}
