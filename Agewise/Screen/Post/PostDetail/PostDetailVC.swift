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
