//
//  CommentView.swift
//  Agewise
//
//  Created by 최대성 on 8/28/24.
//

import UIKit
import SnapKit
import IQKeyboardManagerSwift

final class CommentView: BaseView {
    
    
    let commentTableView = {
        let view = UITableView()
        view.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        view.showsVerticalScrollIndicator = false
        view.rowHeight = 80
        return view
    }()
    let textField = {
       let text = UITextField()
        text.placeholder = "댓글을 입력하세요."
        text.layer.cornerRadius = 10
        text.layer.borderWidth = 1
        text.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        text.leftViewMode = .always
        return text
    }()
    let uploadButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "paperplane"), for: .normal)
        return btn
    }()
    
    
    override func configureLayout() {
        
        addSubview(commentTableView)
        addSubview(textField)
        addSubview(uploadButton)

        commentTableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(textField.snp.top)
        }
        
        textField.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        uploadButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(textField)
            make.trailing.equalTo(textField).inset(5)
            make.width.equalTo(50)
        }
        
    }
}
