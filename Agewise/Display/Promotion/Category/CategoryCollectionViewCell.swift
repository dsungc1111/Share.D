//
//  CategoryCollectionViewCell.swift
//  Agewise
//
//  Created by 최대성 on 8/15/24.
//

import UIKit
import SnapKit
import RxSwift

final class CategoryCollectionViewCell: UICollectionViewCell {
    
    
    enum CategoryLogoImage: String, CaseIterable {
        case teen
        case graduation
        case developer
    }
    
    enum CategoryTitle: String, CaseIterable {
        case teen = "10대"
        case graduation = "20대"
        case developer = "30대"
        case parent = "40대"
        case l = "50대"
        case grand = "60대+"
    }
    
    let button = {
        let btn = UIButton()
        btn.contentMode = .center
        return btn
    }()
    let label = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    func configureHierarchy() {
        contentView.addSubview(button)
        contentView.addSubview(label)
    }
    
    func configureLayout() {
        button.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom)
            make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
//        button.layer.cornerRadius = frame.width/2
        clipsToBounds = true
//        layer.cornerRadius = frame.width/2
    }
    
    func cellConfiguration(item: Int) {
        
        if item < 3 {
            button.setImage(UIImage(named: CategoryLogoImage.allCases[item].rawValue), for: .normal)
        }
        label.text = CategoryTitle.allCases[item].rawValue
    }
}
