//
//  CategoryCollectionViewCell.swift
//  Agewise
//
//  Created by 최대성 on 8/15/24.
//

import UIKit
import SnapKit
import RxSwift

final class CategoryCollectionViewCell: BaseCollectionViewCell {
    
    
    enum CategoryLogoImage: String, CaseIterable {
        case teen
        case worker
        case main
        case parent
        case elderly1
        case elderly2
    }
    
    enum CategoryTitle: String, CaseIterable {
        case teen = "10대"
        case graduation = "20대"
        case developer = "30대"
        case parent = "40대"
        case l = "50대"
        case grand = "60대+"
    }
    
    let ageButton = {
        let btn = UIButton()
        btn.contentMode = .center
        btn.isEnabled = false
        return btn
    }()
    let ageLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    var disposeBag = DisposeBag()
    
 
 
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(ageButton)
        contentView.addSubview(ageLabel)
    }
    
    override func configureLayout() {
        ageButton.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
        ageLabel.snp.makeConstraints { make in
            make.top.equalTo(ageButton.snp.bottom)
            make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
//        button.layer.cornerRadius = frame.width/2
//        clipsToBounds = true
//        layer.cornerRadius = frame.width/2
    }
    
    func cellConfiguration(item: Int) {
        
        ageButton.setImage(UIImage(named: CategoryLogoImage.allCases[item].rawValue), for: .normal)
        
        ageLabel.text = CategoryTitle.allCases[item].rawValue
    }
}
