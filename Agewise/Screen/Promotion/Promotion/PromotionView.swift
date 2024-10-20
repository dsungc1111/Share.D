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
    
    let searchBar = {
        let bar = UISearchBar()
        bar.placeholder = "상품을 검색하세요."
        return bar
    }()
    
    let promotionView = {
        let btn = UIButton()
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .black
        btn.setImage(UIImage(named: "sale"), for: .normal)
        btn.contentMode = .center
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        return btn
    }()
    
    private let recommendLabel = {
        let label = UILabel()
        label.text = "Recommed For Present"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 10
        let cellSpacing: CGFloat = 10
        layout.itemSize = CGSize(width: 80, height: 100)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: 0, bottom: sectionSpacing, right: 0)
        return layout
    }
    
    private let recommendItemLabel = {
        let label = UILabel()
        label.text = "요즘 인기에요!"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let moreBtn: UIButton = {
        let btn = UIButton()

        btn.setTitle("더보기", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.setTitleColor(.lightGray, for: .normal)

        return btn
    }()
    
    lazy var itemCollectionView = UICollectionView(frame: .zero, collectionViewLayout: itemCollectionViewLayout())
    private func itemCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 10
        let cellSpacing: CGFloat = 10
        let deviceWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: deviceWidth / 2 - 20 , height: 300)
        layout.minimumInteritemSpacing = cellSpacing / 2
        layout.minimumLineSpacing = cellSpacing / 2
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: 0, bottom: sectionSpacing, right: 0)
        return layout
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        itemCollectionView.register(AdCollectionViewCell.self, forCellWithReuseIdentifier: AdCollectionViewCell.identifier)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(searchBar)
        contentView.addSubview(promotionView)
        contentView.addSubview(recommendLabel)
        contentView.addSubview(categoryCollectionView)
        contentView.addSubview(recommendItemLabel)
        contentView.addSubview(itemCollectionView)
        contentView.addSubview(moreBtn)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(5)
            make.height.equalTo(40)
        }
        promotionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(200)
        }
        recommendLabel.snp.makeConstraints { make in
            make.top.equalTo(promotionView.snp.bottom).offset(25)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(30)
        }
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(250)
        }
        categoryCollectionView.showsHorizontalScrollIndicator = false
        recommendItemLabel.snp.makeConstraints { make in
            
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(10)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(20)
        }
        moreBtn.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(20)
        }
        itemCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendItemLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(1600)
            make.bottom.equalTo(contentView.snp.bottom).inset(20)
        }
        
        scrollView.showsVerticalScrollIndicator = false
    }
}
