//
//  PostDetailView.swift
//  Agewise
//
//  Created by 최대성 on 8/21/24.
//

import UIKit
import SnapKit

final class PostDetailView: BaseView {
    
    let imageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let writerLabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        return label
    }()
    let dateLabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        return label
    }()
    let contentLabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        return label
    }()
    
    override func configureHierarchy() {
        addSubview(imageView)
        addSubview(writerLabel)
        addSubview(dateLabel)
        addSubview(contentLabel)
    }
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(250)
        }
        writerLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.leading.equalTo(safeAreaLayoutGuide).inset(10)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
    }
}
