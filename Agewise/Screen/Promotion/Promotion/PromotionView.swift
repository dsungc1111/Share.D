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
        label.text = "카테고리"
        label.textColor = UIColor(hexCode: MainColor.main.rawValue)
        label.font = .boldSystemFont(ofSize: 35)
        return label
    }()
//    private let recommendLabel = {
//        let label = UILabel()
//        label.text = "Recommend"
//        label.textColor = UIColor(hexCode: MainColor.main.rawValue)
//        label.font = UIFont(name: "Copperplate-Bold", size: 35)
//        return label
//    }()
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
        layout.sideItemScale = 0.8
        layout.sideItemAlpha = 0.8
//        layout.spacing = 5
        layout.isPagingEnabled = true
        return layout
    }
    
    private let searchView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "#F0A851", alpha: 1)
        view.layer.cornerRadius = 20
        return view
    }()
    private let searchViewImage = {
        let view = UIImageView()
        view.image = UIImage(named: "search")
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let searchLabel = {
        let label = UILabel()
        label.text = "With Keyword"
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    private let guideLine = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let keywordLabel = {
        let label = UILabel()
        label.text = "키워드로 검색하기 ＞"
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        adCollectionView.register(AdCollectionViewCell.self, forCellWithReuseIdentifier: AdCollectionViewCell.identifier)
        adCollectionView.showsHorizontalScrollIndicator = false
        adCollectionView.isPagingEnabled = false
        
        
        recommendCollectionView.register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
        recommendCollectionView.showsVerticalScrollIndicator = false
        recommendCollectionView.isPagingEnabled = false
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
//        contentView.addSubview(recommendLabel)
        contentView.addSubview(hotDealLabel)
        contentView.addSubview(adCollectionView)
        contentView.addSubview(recommendCollectionView)
        contentView.addSubview(searchView)
        contentView.addSubview(searchViewImage)
        contentView.addSubview(searchLabel)
        contentView.addSubview(guideLine)
        contentView.addSubview(keywordLabel)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        hotDealLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(35)
        }
        recommendCollectionView.snp.makeConstraints { make in
            make.top.equalTo(hotDealLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(400)
        }
//        adCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(recommendCollectionView.snp.bottom).offset(30)
//            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
//            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
//            make.height.equalTo(400)
//            make.bottom.equalTo(contentView.snp.bottom)
//        }
        searchView.snp.makeConstraints { make in
            make.top.equalTo(recommendCollectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(170)
            make.bottom.equalTo(contentView.snp.bottom).inset(200)
        }
        searchViewImage.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.top)
            make.leading.equalTo(searchView.snp.leading).inset(20)
            make.height.equalTo(100)
            make.width.equalTo(120)
        }
        searchLabel.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.top).inset(70)
            make.leading.equalTo(searchView.snp.leading).inset(30)
        }
        guideLine.snp.makeConstraints { make in
            make.top.equalTo(searchLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(searchView.snp.horizontalEdges).inset(20)
            make.height.equalTo(1)
        }
        keywordLabel.snp.makeConstraints { make in
            make.top.equalTo(guideLine.snp.bottom).offset(10)
            make.trailing.equalTo(searchView.snp.trailing).inset(20)
        }
        scrollView.showsVerticalScrollIndicator = false
       
    }
    
    
}
