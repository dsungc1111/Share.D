//
//  ProductDetailVC.swift
//  Agewise
//
//  Created by 최대성 on 8/18/24.
//

import UIKit
import RxSwift

final class ProductDetailVC: BaseVC {

    var product: ProductDetail?
    
    private let productDetailView = ProductDetailView()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = productDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureWebview()
    }
  
    override func configureNavigationBar() {
        let rightBarButton = UIBarButtonItem(title: "👉 질문하기", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = rightBarButton
        
        
        rightBarButton.rx.tap
            .bind(with: self) { owner, _ in
                print("질문하기 go!")
                let vc = QuestionVC()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureWebview() {
        guard let link = product?.link else { return }
        guard let url = URL(string: link) else { return }
        
        let request = URLRequest(url: url)
        
        productDetailView.webView.load(request)
    }
}
