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
    
    var result: PostModelToWrite?
    
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
        
        guard let result = result else {
            print("없어~")
            return
        }
        
        print(result)
        
        let input = CommentVM.Input(trigger: Observable.just(result), comment: commentView.textField.rx.text.orEmpty, uploadButtonTap: commentView.uploadButton.rx.tap)
        
        let output = commentVM.transform(input: input)
        
        output.commentList
            .bind(to: commentView.commentTableView.rx.items(cellIdentifier: CommentTableViewCell.identifier, cellType: CommentTableViewCell.self)) { (row, element, cell) in
                
                cell.configureCell(element: element)
                
                
            }
            .disposed(by: disposeBag)
        
    }
}
