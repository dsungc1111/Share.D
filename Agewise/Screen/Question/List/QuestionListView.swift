//
//  QuestionListView.swift
//  Agewise
//
//  Created by 최대성 on 8/18/24.
//

import UIKit
import SnapKit

final class QuestionListView: BaseView {
    
    
    let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: categoryLayout())
    
    private static func categoryLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellSpacing: CGFloat = 10
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 60)
        layout.minimumInteritemSpacing = cellSpacing
        return layout
    }
    
    
    let resultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: resultCollectionViewLayout())
    private static func resultCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 10
        let cellSpacing: CGFloat = 10
        let width = UIScreen.main.bounds.width
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: 100)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        categoryCollectionView.register(ListCategoryCollectionViewCell.self, forCellWithReuseIdentifier: ListCategoryCollectionViewCell.identifier)
        
        resultCollectionView.register(QuestionListCollectionViewCell.self, forCellWithReuseIdentifier: QuestionListCollectionViewCell.identifier)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureLayout() {
        addSubview(categoryCollectionView)
        addSubview(resultCollectionView)
        
        categoryCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(70)
        }
        categoryCollectionView.backgroundColor = .systemPink
        resultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
