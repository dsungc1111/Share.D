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
    case accessError =  "접근권한이 없습니다."
}

final class PostVM: BaseViewModel {
    
    
    struct Input {
        let saveTap: ControlEvent<Void>
        let question: ControlProperty<String>
        let category: Observable<String>
        let productInfo: Observable<ProductDetail>
    }
    struct Output {
        let result: Observable<Bool>
        let success: PublishSubject<String>
    }
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let success = PublishSubject<String>()
        
        let result = input.question
            .map { $0.count != 0 }
        
        
        let combined = Observable.combineLatest(input.productInfo, input.question, input.category)
        
        
        input.saveTap
            .withLatestFrom(combined)
            .bind(with: self) { owner, result in
                
                let product = result.0
                let text = result.1
                let category = result.2
                
                let save = PostQuery(title: product.title, price: Int(product.lprice) ?? 0, content: text, content1: product.mallName, content2: product.productId, product_id: category + "선물용" , files: [product.image])
                
                NetworkManager.shared.writePost(query: save) { result in
                    
                    success.onNext(owner.judgeStatusCode(statusCode: result, title: SuccessKeyword.post.rawValue))
                    
                }
            }
            .disposed(by: disposeBag)
        
//        input.saveTap
//            .withLatestFrom(combined)
//            .map { result in
//                let product = result.0
//                let text = result.1
//                let category = result.2
//                
//                let save = PostQuery(title: product.title, price: Int(product.lprice) ?? 0, content: text, content1: product.mallName, content2: product.productId, product_id: category + "선물용" , files: [product.image])
//                
//                return save
//            }
//            .flatMap { result in
//                
//                PostNetworkManager.shared.postNetworkManager(api: .postQuestion(query: result), model: PostModelToWrite.self)
//                    
//                
//            }
//            .subscribe(with: self, onNext: { owner, result in
//                print("tlfgod")
//                print(result)
////                let statuscode = result.statuscode
////                guard let data = result.data else { return }
////                print("저장 statuscode", statuscode)
////                print("저장 데이터 = ", data)
////                let message = owner.judgeStatusCode(statusCode: statuscode, title: SuccessKeyword.post.rawValue)
////                success.onNext(message)
//            })
//            .disposed(by: disposeBag)
        
        return Output(result: result, success: success)
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
