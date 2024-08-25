//
//  QuestionListView.swift
//  Agewise
//
//  Created by 최대성 on 8/18/24.
//

import UIKit
import SnapKit

final class PostListView: BaseView {
    
    
    let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: categoryLayout())
    
    private static func categoryLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 60)
        return layout
    }
    
    
    let resultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: resultCollectionViewLayout())
    private static func resultCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 10
        let cellSpacing: CGFloat = 10
        let width = UIScreen.main.bounds.width
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: 150)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        categoryCollectionView.register(ListCategoryCollectionViewCell.self, forCellWithReuseIdentifier: ListCategoryCollectionViewCell.identifier)
        categoryCollectionView.showsHorizontalScrollIndicator = false
        
        resultCollectionView.register(PostListCollectionViewCell.self, forCellWithReuseIdentifier: PostListCollectionViewCell.identifier)
        resultCollectionView.showsVerticalScrollIndicator = false
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureLayout() {
        addSubview(categoryCollectionView)
        addSubview(resultCollectionView)
       
        categoryCollectionView.snp.makeConstraints { make in
            make.top.trailing.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
        }
        resultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(10)
        }
       
    }
}
