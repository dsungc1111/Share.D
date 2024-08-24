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
 
    
    override func bind() {
        var title = ""
        
        let input = DetailPostVM.Input(trigger: Observable.just(element))
        
        let output = detailPostVM.transform(input: input)
        
        output.detailInfo
            .bind(with: self) { owner, result in
                owner.postDetailView.configurePostDetail(element: result)
                owner.navigationItem.title = result.productId
                
                if UserDefaultManager.shared.userId == result.creator.userId {
                    title = "✍️ 수정하기"
                } else {
                    owner.navigationItem.rightBarButtonItem = nil
                }
                
                let editButton = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
                owner.navigationItem.rightBarButtonItem = editButton
                
                editButton.rx.tap
                    .bind(with: self) { owner, _ in
                        let vc = PostVC()
                        vc.postView.editView(result: result)
                        vc.navigationItem.title = "질문 수정"
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
    }
}
