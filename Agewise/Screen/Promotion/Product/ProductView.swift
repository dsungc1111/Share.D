//
//  ProductDetailView.swift
//  Agewise
//
//  Created by 최대성 on 8/17/24.
//

import UIKit
import WebKit
import SnapKit

final class ProductView: BaseView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    private static func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 10
        let cellSpacing: CGFloat = 10
        let width = UIScreen.main.bounds.width
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width / 2 - 20, height: 300)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func configureLayout() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
}
