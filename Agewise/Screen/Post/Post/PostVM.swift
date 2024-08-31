//
//  QuestionViewModel.swift
//  Agewise
//
//  Created by 최대성 on 8/19/24.
//

import Foundation
import RxSwift
import RxCocoa

enum SuccessKeyword: String {
    case signUp = "회원가입 성공!"
    case login = "로그인 성공!"
    case post = "업로드 성공!"
}

final class PostVM: BaseViewModel {
    
    
    deinit {
        print("**", #function)
        print("====PostVM deinit======")
    }
    
    struct Input {
        let saveTap: ControlEvent<Void>
        let question: ControlProperty<String>
        let category: Observable<String>
        let productInfo: Observable<ProductDetail>
        let editOrWrite: Observable<Bool>
    }
    struct Output {
        let result: Observable<Bool>
        let success: PublishSubject<String>
        let errorMaessage: PublishSubject<String>
    }
    private let disposeBag = DisposeBag()
    
    private var editOrWrite = false
    private let errorMessage = PublishSubject<String>()
    
    override init() {
        print("postVM init")
    }
    
    func transform(input: Input) -> Output {
        
        input.editOrWrite
            .bind(with: self) { owner, result in
                owner.editOrWrite = result
                
                print("질문 or 작성", owner.editOrWrite)
            }
            .disposed(by: disposeBag)
        
        
        let successMent = PublishSubject<String>()
        
        let result = input.question
            .map { $0.count != 0 }
        
        let combined = Observable.combineLatest(input.productInfo, input.question, input.category)
        
        
        input.saveTap
            .withLatestFrom(combined)
            .map { result in
                let product = result.0
                let text = result.1
                let category = result.2
                
                let save = PostQuery(title: product.title, price: Int(product.lprice) ?? 0, content: text, content1: product.mallName, content2: product.productId, product_id: category + "선물용" , files: [product.image])
                return save
                
            }
            .bind(with: self) { owner, result in
                
                
                PostNetworkManager.shared.networking(api: .postQuestion(query: result), model: PostModelToWrite.self) { result in
                    
                    switch result {
                    case .success(let success):
                        let message = owner.judgeStatusCode(statusCode: success.0, title: SuccessKeyword.post.rawValue)
                        successMent.onNext(message)
                    case .failure(let error):
                        if error == .expierdRefreshToken {
                            owner.errorMessage.onNext("만료됨")
                        }
                    }
                }
                
            }
            .disposed(by: disposeBag)
        
        
        
        return Output(result: result, success: successMent, errorMaessage: errorMessage)
    }
    
    override func judgeStatusCode(statusCode: Int, title: String) -> String {
        var message = super.judgeStatusCode(statusCode: statusCode, title: title)
        
        switch statusCode {
        case 200 :
            message = title
        case 401:
            message = "유효하지 않은 액세스 토큰"
        case 410:
            message = "생성된 게시글 X" // DB서버 장애로 게시글이 저장되지 않았을 때
        default:
            message = "기타 에러"
        }
        
        return message
    }
}
