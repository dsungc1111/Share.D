//
//  SettingDetailView.swift
//  Agewise
//
//  Created by 최대성 on 8/28/24.
//

import UIKit
import SnapKit

final class SettingDetailView: BaseView {
    
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    private static func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 10
        let cellSpacing: CGFloat = 10
        let width = UIScreen.main.bounds.width
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width / 2 - 30, height: 300)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    
    
    override func configureLayout() {
        addSubview(collectionView)
        collectionView.register(SettingDetailCollectionViewCell.self, forCellWithReuseIdentifier: SettingDetailCollectionViewCell.identifier)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        collectionView.backgroundColor = .lightGray
    }
    
}
