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

final class QuestionVC: BaseVC {

    
    var productInfo: ProductDetail?
    
    var category = ""
    
    private let questionView = QuestionView()
    
    private let questionViewModel = QuestionViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var showToast: (() -> Void)?
    
    override func loadView() {
        view = questionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func configureNavigationBar() {
        navigationItem.title = "질문작성"
    }
    
    override func bind() {
        
        guard let product = productInfo else { return }
        
        questionView.configureView(product: product)
        
        
        
        let input = QuestionViewModel.Input(saveTap: questionView.saveButton.rx.tap, question: questionView.textView.rx.text.orEmpty, category: Observable.just(category), productInfo: Observable.just(product))
        
        let output = questionViewModel.transform(input: input)
        
        output.result
            .bind(with: self) { owner, result in
                owner.questionView.saveButton.isEnabled = result
                owner.questionView.saveButton.backgroundColor = result ? .black : .lightGray
            }
            .disposed(by: disposeBag)
        
        
        output.success
            .bind(with: self) { owner, result in
                if result == SuccessKeyword.post.rawValue {
                   print("업로드 성공")
                } else if result == SuccessKeyword.accessError.rawValue {
                    self.expiredToken(title: "로그인 화면으로 돌아감.")
                } else {
                    owner.view.makeToast(result, duration: 2.0, position: .bottom)
                }
            }
            .disposed(by: disposeBag)
    }
    
}
