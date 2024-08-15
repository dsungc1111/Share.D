//
//  MainView.swift
//  Agewise
//
//  Created by 최대성 on 8/15/24.
//

import UIKit
import SnapKit

final class PromotionView: BaseView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    
    let adCollectionView = UICollectionView(frame: .zero, collectionViewLayout: adCollectionViewLayout())
    private static func adCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 10
        let cellSpacing: CGFloat = 10
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 56, height: 56)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: 0)
        return layout
    }
  
    
    let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: categoryCollectionViewLayout())
    private static func categoryCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 10
        let cellSpacing: CGFloat = 10
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 90, height: 90)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: 2*sectionSpacing, bottom: sectionSpacing, right: 2*sectionSpacing)
        return layout
    }
    
    let stateLabel = {
        let label = UILabel()
        label.text = "카테고리를 선택해주세요!"
        label.textAlignment = .center
        return label
    }()
    
    let trendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: trendCollectionViewLayout())
    
    private static func trendCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellSpacing: CGFloat = 10
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 150, height: 50)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
        return layout
    }
    
    override init(frame: CGRect) {
          super.init(frame: frame)
        
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        categoryCollectionView.showsVerticalScrollIndicator = false
        
        trendCollectionView.register(TrendCollectionViewCell.self, forCellWithReuseIdentifier: TrendCollectionViewCell.identifier)
        trendCollectionView.showsVerticalScrollIndicator = false
      }
      
      @available(*, unavailable)
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(adCollectionView)
        contentView.addSubview(categoryCollectionView)
        contentView.addSubview(stateLabel)
        contentView.addSubview(trendCollectionView)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
            
        }
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        
        adCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(200)
        }
        adCollectionView.layer.cornerRadius = 15
        adCollectionView.backgroundColor = .lightGray
        
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(adCollectionView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(210)
        }
        stateLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(30)
        }
        stateLabel.backgroundColor = .lightGray
        
        trendCollectionView.snp.makeConstraints { make in
            make.top.equalTo(stateLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(300)
            make.bottom.equalTo(contentView.snp.bottom)

        }
        trendCollectionView.backgroundColor = .lightGray
    }
}
