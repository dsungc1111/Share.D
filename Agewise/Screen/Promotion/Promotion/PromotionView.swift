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
        label.font = UIFont(name: "Copperplate-Bold", size: 30)
        label.text = "요즘 인기 TOP10"
        label.textColor = UIColor(hexCode: MainColor.main.rawValue, alpha: 1)
        return label
    }()
    
    let adCollectionView = UICollectionView(frame: .zero, collectionViewLayout: adCollectionViewLayout())
    private static func adCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width - 20, height: 400)
        return layout
    }
    let backView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: MainColor.main.rawValue, alpha: 1)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        return view
    }()
    let stateLabel = {
        let label = UILabel()
        label.text = "누구에게 선물하시나요?"
        label.textColor = .black
        label.font = UIFont(name: "Copperplate-Bold", size: 24)
        label.clipsToBounds = true
        label.textColor = .white
        return label
    }()
    let ageButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("연령대", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .white
        let ageGroups = ["10대", "20대", "30대", "40대", "50대", "60대+"]
        
        var buttons: [UIAction] = []
        
        for i in 0..<ageGroups.count {
            let ages = UIAction(title: ageGroups[i]) { [weak btn] _ in
                btn?.setTitle(ageGroups[i], for: .normal)
            }
            buttons.append(ages)
        }
        
        btn.showsMenuAsPrimaryAction = true
        btn.menu = UIMenu(title: "연령대 선택", options: .displayInline, children: buttons)
        
        return btn
    }()
    let genderButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("성별", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .white
        let ageGroups = ["남성", "여성"]
        
        var buttons: [UIAction] = []
        
        for i in 0..<ageGroups.count {
            let ages = UIAction(title: ageGroups[i]) { [weak btn] _ in
                btn?.setTitle(ageGroups[i], for: .normal)
            }
            buttons.append(ages)
        }
        btn.showsMenuAsPrimaryAction = true
        btn.menu = UIMenu(title: "성별 선택", options: .displayInline, children: buttons)
        
        return btn
    }()
    let selectLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "에게 선물할거에요."
        label.textColor = .white
        return label
    }()
    let searchButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("😀 추천받기", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = .white
        return btn
    }()
    
    let recommendLabel = {
        let label = UILabel()
        label.font = UIFont(name: "Copperplate-Bold", size: 24)
        label.text = "추천 상품"
        label.textColor = UIColor(hexCode: MainColor.main.rawValue, alpha: 1)
        return label
    }()
    
    let recommendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: recommendCollectionViewLayout())
    
    private static func recommendCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellSpacing: CGFloat = 10
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 140, height: 50)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
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
        contentView.addSubview(hotDealLabel)
        contentView.addSubview(adCollectionView)
        contentView.addSubview(backView)
        contentView.addSubview(stateLabel)
        contentView.addSubview(recommendCollectionView)
        contentView.addSubview(ageButton)
        contentView.addSubview(genderButton)
        contentView.addSubview(selectLabel)
        contentView.addSubview(recommendLabel)
        contentView.addSubview(searchButton)
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
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(40)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(35)
        }
        adCollectionView.snp.makeConstraints { make in
            make.top.equalTo(hotDealLabel.snp.bottom)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(450)
        }
        backView.snp.makeConstraints { make in
            make.top.equalTo(adCollectionView.snp.bottom).offset(10)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(120)
        }
        stateLabel.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.top).inset(10)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(30)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(35)
        }
        ageButton.snp.makeConstraints { make in
            make.top.equalTo(stateLabel.snp.bottom).offset(10)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(40)
            make.width.equalTo(60)
        }
        genderButton.snp.makeConstraints { make in
            make.top.equalTo(stateLabel.snp.bottom).offset(10)
            make.leading.equalTo(ageButton.snp.trailing).offset(10)
            make.height.equalTo(40)
            make.width.equalTo(50)
        }
        selectLabel.snp.makeConstraints { make in
            make.top.equalTo(stateLabel.snp.bottom).offset(20)
            make.leading.equalTo(genderButton.snp.trailing).offset(5)
            make.width.equalTo(120)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(stateLabel.snp.bottom).offset(10)
            make.leading.equalTo(selectLabel.snp.trailing).offset(5)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
        }
        recommendLabel.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.bottom).offset(20)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(40)
        }
        recommendCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(300)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        
    }

}
