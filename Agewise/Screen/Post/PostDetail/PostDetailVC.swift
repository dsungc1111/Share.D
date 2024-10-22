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
    
    var productPrice = 0
    
    var model: PostModelToWrite?
    
    private let disposeBag = DisposeBag()
    
    
    override func loadView() {
        view = postDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.backgroundImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
 
    override func configureNavigationBar() {
        
        navigationItem.title = "질문"
    }
    
    override func bind() {
        
        let input = DetailPostVM.Input(trigger: Observable.just(element), 
                                       likeTap: postDetailView.likeButton.rx.tap
        )
        
        let output = detailPostVM.transform(input: input)
        
        output.detailInfo
            .bind(with: self) { owner, result in
                
                owner.postDetailView.configurePostDetail(element: result)
                owner.productPrice = result.price ?? 100
                owner.model = result
            }
            .disposed(by: disposeBag)
        
        
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
        
        output.errorMessage
            .bind(with: self) { owner, value in
                owner.logoutUser()
            }
            .disposed(by: disposeBag)
        
        postDetailView.buyButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = PaymentVC()
                vc.payInfo = owner.model
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        
    }
    
    @objc func dataReceived(_ notification: Notification ) {
        
        if let count = notification.object as? Int {
            postDetailView.commentButton.setTitle("\(count)", for: .normal)
        }
    }
}
