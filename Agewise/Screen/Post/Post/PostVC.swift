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
    
    var result: PostModelToWrite?
    
    let postView = PostView()
    
    private let postVM = PostVM()
    
    private let disposeBag = DisposeBag()
    
    private var showToast: (() -> Void)?
    
    var editOrWrite = false
    
    override func loadView() {
        view = postView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("게시물 포스트 화면")
        
    }
    
    override func configureNavigationBar() {
        
        if editOrWrite == false {
            navigationItem.title = "질문작성"
        } else {
            navigationItem.title = "질문수정"
        }
    }
    
    override func bind() {
        
        print("**", #function)
        guard let product = productInfo else { return }
        
        postView.configureView(product: product)
        
        let input = PostVM.Input(
            saveTap: postView.saveButton.rx.tap,
            question: postView.textView.rx.text.orEmpty,
            productInfo: Observable.just(product),
            editOrWrite: Observable.just(editOrWrite)
        )
        
        let output = postVM.transform(input: input)
        
        
        output.result
            .bind(with: self) { owner, result in
                owner.postView.saveButton.isEnabled = result
                owner.postView.saveButton.backgroundColor = result ? UIColor(hexCode: MainColor.main.rawValue) : .lightGray
            }
            .disposed(by: disposeBag)
        
        
        output.success
            .bind(with: self) { owner, result in
                print(result)
                if owner.editOrWrite == false {
                    if result == SuccessKeyword.post.rawValue {
                        print("업로드 성공")
                        let vc = TabBarController()
                        owner.resetViewWithoutNavigation(vc: vc)
                        vc.selectedIndex = 0
                    } else {
                        owner.view.makeToast(result, duration: 2.0, position: .bottom)
                    }
                } else {
                    print("수정성공")
                }
            }
            .disposed(by: disposeBag)
        
        output.errorMaessage
            .bind(with: self) { owner, result in
                owner.logoutUser()
            }
            .disposed(by: disposeBag)
        
        
//        postView.ageButton.rx.tap
//            .bind(with: self) { owner, _ in
//                let ageMenuItems: [UIAction] = [
//                    UIAction(title: "10대", handler: { _ in owner.handleAgeSelection("10대") }),
//                    UIAction(title: "20대", handler: { _ in owner.handleAgeSelection("20대") }),
//                    UIAction(title: "30대", handler: { _ in owner.handleAgeSelection("30대") }),
//                    UIAction(title: "40대", handler: { _ in owner.handleAgeSelection("40대") }),
//                    UIAction(title: "50대", handler: { _ in owner.handleAgeSelection("50대") }),
//                    UIAction(title: "60대", handler: { _ in owner.handleAgeSelection("60대") })
//                ]
////                
//                let menu = UIMenu(title: "나이를 선택하세요", children: ageMenuItems)
//                owner.postView.ageButton.menu = menu
//                
//                owner.postView.ageButton.showsMenuAsPrimaryAction = true
//
//                print("탭")
//            }
//            .disposed(by: disposeBag)
        
    }
//    private func handleAgeSelection(_ ageRange: String) {
//           print("선택된 나이대: \(ageRange)")
//        postView.ageButton.setTitle(ageRange, for: .normal)
//        postVM.age = ageRange
//       }
    
}
