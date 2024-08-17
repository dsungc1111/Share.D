//
//  ProductDetailVC.swift
//  Agewise
//
//  Created by 최대성 on 8/17/24.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class ProductVC: BaseVC {

    private let productView = ProductView()
    
    private let productViewModel = ProductViewModel()
    
    private let disposeBag = DisposeBag()
    
    var productList: [ProductDetail]?
    
    override func loadView() {
        view = productView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        guard let list = productList else { return }
        
        
        let input = ProductViewModel.Input(list: Observable.just(list))
        
        let output = productViewModel.transform(input: input)
        
        output.list
            .bind(to: productView.collectionView.rx.items(cellIdentifier: ProductCollectionViewCell.identifier, cellType: ProductCollectionViewCell.self)) { (row, element, cell) in
                
                let image = URL(string: element.image)
                
                cell.companyNameLabel.text = element.mallName
                cell.imageView.kf.setImage(with: image)
                cell.priceLabel.text = (Int(element.lprice)?.formatted() ?? "0") + "원"
                cell.productNameLabel.text = element.title.removeHtmlTag
                
                
            }
            .disposed(by: disposeBag)
        
      
        
    }
}
