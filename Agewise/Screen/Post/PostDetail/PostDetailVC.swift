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
    
    var model: PostModelToWrite?
    
    private let disposeBag = DisposeBag()
    
    
    override func loadView() {
        view = postDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    override func configureNavigationBar() {
        
        
    }
    
    override func bind() {
        
        let input = DetailPostVM.Input(trigger: Observable.just(element), likeTap: postDetailView.likeButton.rx.tap)
        
        let output = detailPostVM.transform(input: input)
        
        output.detailInfo
            .bind(with: self) { owner, result in
                print("바뀌는데")
                owner.postDetailView.configurePostDetail(element: result)
                owner.navigationItem.title = result.productId
                owner.model = result
            }
            .disposed(by: disposeBag)
        
        // clean build cmd + shift + k
        postDetailView.commentButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = CommentVC()
                vc.result = owner.model
                
                vc.modalPresentationStyle = .pageSheet
                
                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [.medium(), .large()]
                    sheet.prefersGrabberVisible = true
                }
                NotificationCenter
                    .default
                    .addObserver(self,
                                 selector: #selector(owner.dataReceived(_:)),
                                 name: NSNotification.Name("commentCount"),
                                 object: nil
                    )
                
                owner.present(vc, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
    }
    
    @objc func dataReceived(_ notification: Notification ) {
        
        if let count = notification.object as? Int {
            postDetailView.commentButton.setTitle("\(count)", for: .normal)
        }
    }
}
