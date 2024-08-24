//
//  QuestionVC.swift
//  Agewise
//
//  Created by 최대성 on 8/19/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class PostVC: BaseVC {

    
    var productInfo: ProductDetail?
    
    var category = ""
    
    let postView = PostView()
    
    private let postVM = PostVM()
    
    private let disposeBag = DisposeBag()
    
    private var showToast: (() -> Void)?
    
    override func loadView() {
        view = postView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "질문작성"
    }
    
    override func bind() {
        
        guard let product = productInfo else { return }
        
        postView.configureView(product: product)
        
        
        
        let input = PostVM.Input(saveTap: postView.saveButton.rx.tap, question: postView.textView.rx.text.orEmpty, category: Observable.just(category), productInfo: Observable.just(product))
        
        let output = postVM.transform(input: input)
        
        output.result
            .bind(with: self) { owner, result in
                owner.postView.saveButton.isEnabled = result
                owner.postView.saveButton.backgroundColor = result ? .black : .lightGray
            }
            .disposed(by: disposeBag)
        
        
        output.success
            .bind(with: self) { owner, result in
                print(result)
                if result == SuccessKeyword.post.rawValue {
                   print("업로드 성공")
                    let vc = TabBarController()
                    owner.resetViewWithoutNavigation(vc: vc)
                    vc.selectedIndex = 0
                } else if result == SuccessKeyword.accessError.rawValue {
                    owner.withdrawUser {
                        print("로그아웃")
                    }
                } else {
                    owner.view.makeToast(result, duration: 2.0, position: .bottom)
                }
            }
            .disposed(by: disposeBag)
    }
    
}
