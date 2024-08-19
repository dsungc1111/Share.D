//
//  QuestionView.swift
//  Agewise
//
//  Created by 최대성 on 8/19/24.
//

import UIKit
import SnapKit

final class QuestionView: BaseView {
    
    let imageContainer = {
        let container = UIView()
        container.backgroundColor = .lightGray
        return container
    }()
//    let imageButton = {
//        var config = UIButton.Configuration.plain()
//        
//        config.attributedTitle = "이미지"
//        config.image = UIImage(systemName: "plus.circle")
//        config.imagePlacement = .leading
//        config.imagePadding = 10
//        
//        let button = UIButton(configuration: config)
//        return button
//    }()
    
    let infoLabel = {
        let label = UILabel()
        label.text = "제품정보란"
        return label
    }()
    let mallnameLabel = {
        let label = UILabel()
        label.text = "쇼핑몰"
        return label
    }()
    
    let textView = {
        let text = UITextView()
        text.layer.borderWidth = 1
        text.layer.cornerRadius = 10
        text.font = .systemFont(ofSize: 13)
        text.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)
        return text
    }()
    
    let saveButton = {
        let btn = UIButton()
        btn.setTitle("저장", for: .normal)
        btn.backgroundColor = .systemGray
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(imageContainer)
        addSubview(textView)
        addSubview(infoLabel)
        addSubview(mallnameLabel)
        addSubview(saveButton)
    }
    override func configureLayout() {
        imageContainer.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(250)
        }
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(imageContainer.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).inset(15)
        }
        mallnameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageContainer.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(15)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(15)
            make.height.equalTo(200)
        }
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            make.height.equalTo(60)
        }
    }
    
    
}
