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
    
    private let hotDealLabel = {
        let label = UILabel()
        label.text = "선물 TOP 10"
        label.textColor = UIColor(hexCode: MainColor.main.rawValue)
        label.font = .boldSystemFont(ofSize: 35)
        return label
    }()
    private let recommendLabel = {
        let label = UILabel()
        label.text = "Recommend"
        label.textColor = UIColor(hexCode: MainColor.main.rawValue)
        label.font = .boldSystemFont(ofSize: 35)
        return label
    }()
    let adCollectionView = UICollectionView(frame: .zero, collectionViewLayout: adCollectionViewLayout())
    private static func adCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width - 20, height: 380)
        return layout
    }
    
    let recommendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: recommendCollectionViewLayout())
    
    private static func recommendCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellSpacing: CGFloat = 10
        let width = UIScreen.main.bounds.width
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width - 20, height: 220)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
        return layout
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        adCollectionView.register(AdCollectionViewCell.self, forCellWithReuseIdentifier: AdCollectionViewCell.identifier)
        adCollectionView.showsHorizontalScrollIndicator = false
        adCollectionView.isPagingEnabled = true
        
        
        recommendCollectionView.register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
        recommendCollectionView.showsVerticalScrollIndicator = false
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(recommendLabel)
        contentView.addSubview(hotDealLabel)
        contentView.addSubview(adCollectionView)
        contentView.addSubview(recommendCollectionView)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
            
        }
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        recommendLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(30)
        }
        recommendCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(920)
            
        }
        hotDealLabel.snp.makeConstraints { make in
            make.top.equalTo(recommendCollectionView.snp.bottom)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(35)
        }
        adCollectionView.snp.makeConstraints { make in
            make.top.equalTo(hotDealLabel.snp.bottom).offset(10)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(380)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        scrollView.showsVerticalScrollIndicator = false
       
    }
}
