//
//  ProductDetailView.swift
//  Agewise
//
//  Created by 최대성 on 8/18/24.
//

import UIKit
import SnapKit
import WebKit

final class ProductDetailView: BaseView {
    
    let webView = WKWebView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureLayout() {
        addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        webView.backgroundColor = .lightGray
    }
    
    
}

