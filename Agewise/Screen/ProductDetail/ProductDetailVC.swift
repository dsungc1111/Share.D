//
//  ProductDetailVC.swift
//  Agewise
//
//  Created by 최대성 on 8/18/24.
//

import UIKit

class ProductDetailVC: BaseVC {

    var product: ProductDetail?
    
    private let productDetailView = ProductDetailView()
    
    override func loadView() {
        view = productDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        callRequest()
    }
    private func callRequest() {
        guard let link = product?.link else {
            print("실패")
            return
        }
        guard let url = URL(string: link) else {
            print("실패")
            return
        }
        let request = URLRequest(url: url)
        
        productDetailView.webView.load(request)
        
//        if let url = URL(string: product?.link) {
//            let request = URLRequest(url: url)
//            webView.load(request)
//        } else {
//            let alert = UIAlertController(title: AlertMention.connectionError.rawValue, message: AlertMention.network.rawValue, preferredStyle: .alert)
//            let okButton = UIAlertAction(title: AlertMention.networkChecking.rawValue, style: .default)
//            alert.addAction(okButton)
//            self.present(alert, animated: true)
//        }
    }
}
