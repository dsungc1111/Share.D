//
//  Comment.swift
//  Agewise
//
//  Created by 최대성 on 8/28/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CommentVC: BaseVC {
    
    private let commentView = CommentView()
    
    private let commentVM = CommentVM()
    
    var postId = ""
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = commentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "댓글"
    }
    
    
    override func bind() {
        
        print(#function)
        
        let input = CommentVM.Input(trigger: Observable.just(postId), comment: commentView.textField.rx.text.orEmpty, uploadButtonTap: commentView.uploadButton.rx.tap)
        
        let output = commentVM.transform(input: input)
        
        output.b
//            .bind(with: self, onNext: { owner, result in
//                print(result)
//            })
            .bind(to: commentView.commentTableView.rx.items(cellIdentifier: CommentTableViewCell.identifier, cellType: CommentTableViewCell.self)) { (row, element, cell) in
                
                print("요소", element)
                cell.usernameLabel.text = "\(element)"
                
            }
            .disposed(by: disposeBag)
        
    }
}
