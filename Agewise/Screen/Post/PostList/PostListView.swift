//
//  QuestionListView.swift
//  Agewise
//
//  Created by 최대성 on 8/18/24.
//

import UIKit
import SnapKit

final class PostListView: BaseView {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let genderSegmentedControl: UISegmentedControl = {
        let items = ["남성", "여성"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    let agePickerView = UIPickerView()
    
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
        
       
        resultCollectionView.register(PostListCollectionViewCell.self, forCellWithReuseIdentifier: PostListCollectionViewCell.identifier)
        resultCollectionView.showsVerticalScrollIndicator = false
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(genderSegmentedControl)
        addSubview(agePickerView)
        addSubview(resultCollectionView)
    }
    
    
    override func configureLayout() {
        
        genderSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        agePickerView.snp.makeConstraints { make in
            make.top.equalTo(genderSegmentedControl.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(100)
        }
        
        resultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(agePickerView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(10)
        }
       
    }
}
