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
        label.font = UIFont(name: "Copperplate-Bold", size: 35)
        
        return label
    }()
    let adCollectionView = UICollectionView(frame: .zero, collectionViewLayout: adCollectionViewLayout())
    private static func adCollectionViewLayout() -> UICollectionViewLayout {
        let layout = CarouselLayout()
        let width = UIScreen.main.bounds.width
        let itemWidth = width * 0.9
        let itemHeight: CGFloat = 400
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: (width - itemWidth) / 2 - 50, bottom: 0, right: (width - itemWidth) / 2)
        layout.sideItemScale = 0.8 // Customize this as needed
        layout.sideItemAlpha = 0.8 // Customize this as needed
//        layout.spacing = 5 // Customize this as needed
        layout.isPagingEnabled = true // Adjust this as needed
        return layout
    }
    
    let recommendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: recommendCollectionViewLayout())
    
    private static func recommendCollectionViewLayout() -> UICollectionViewLayout {
        let layout = CarouselLayout()
        let width = UIScreen.main.bounds.width
        let itemWidth = width * 0.8
        let itemHeight: CGFloat = 400
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
//        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: (width - itemWidth) / 2, bottom: 0, right: (width - itemWidth) / 2)
        layout.sideItemScale = 0.8 // Customize this as needed
        layout.sideItemAlpha = 0.8 // Customize this as needed
//        layout.spacing = 5 // Customize this as needed
        layout.isPagingEnabled = true // Adjust this as needed
        return layout
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        adCollectionView.register(AdCollectionViewCell.self, forCellWithReuseIdentifier: AdCollectionViewCell.identifier)
        adCollectionView.showsHorizontalScrollIndicator = false
        adCollectionView.isPagingEnabled = false
        
        
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
//        recommendLabel.snp.makeConstraints { make in
//            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(30)
//            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(30)
//        }
        recommendCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(30)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(450)
        }
        hotDealLabel.snp.makeConstraints { make in
            make.top.equalTo(recommendCollectionView.snp.bottom)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(35)
        }
        adCollectionView.snp.makeConstraints { make in
            make.top.equalTo(hotDealLabel.snp.bottom)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(500)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        scrollView.showsVerticalScrollIndicator = false
       
    }
    
    
}
