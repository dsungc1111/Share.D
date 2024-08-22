//
//  PostDetailVC.swift
//  Agewise
//
//  Created by 최대성 on 8/21/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PostDetailVC: BaseVC {

    private let postDetailView = PostDetailView()
    
    private let detailPostVM = DetailPostVM()
    
    var element = ""
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = postDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureNavigationBar() {
        let editButton = UIBarButtonItem(title: "✍️ 수정하기", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = editButton
        
        editButton.rx.tap
            .bind(with: self) { owner, _ in
                print("클릭")
            }
            .disposed(by: disposeBag)
    }
    
    override func bind() {
        let input = DetailPostVM.Input(trigger: Observable.just(element))
        
        let output = detailPostVM.transform(input: input)
        
        output.detailInfo
            .bind(with: self) { owner, result in
                owner.postDetailView.configurePostDetail(element: result)
                owner.navigationItem.title = result.productId
            }
            .disposed(by: disposeBag)
        
    }
}
