//
//  QuestionVC.swift
//  Agewise
//
//  Created by 최대성 on 8/19/24.
//

import UIKit
import RxSwift
import RxCocoa

final class QuestionVC: BaseVC {

    
    var productInfo: ProductDetail?
    
    var category = ""
    
    private let questionView = QuestionView()
    
    private let questionViewModel = QuestionViewModel()
    
    private let disposeBag = DisposeBag()
    
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
        
        let a = questionView.textView.rx.text.orEmpty
        
        let input = QuestionViewModel.Input(saveTap: questionView.saveButton.rx.tap, question: questionView.textView.rx.text.orEmpty, category: Observable.just(category), productInfo: Observable.just(product))
        
        let output = questionViewModel.transform(input: input)
        
        output.result
            .bind(with: self) { owner, result in
                owner.questionView.saveButton.isEnabled = result
                owner.questionView.saveButton.backgroundColor = result ? .black : .lightGray
            }
            .disposed(by: disposeBag)
    }
    
}
