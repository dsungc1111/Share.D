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
    
    
    let button = {
        let btn = UIButton()
        btn.setTitle("10대", for: .normal)
        return btn
    }()
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemPink
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    
//    override func layoutSubviews() {
//        button.layer.cornerRadius = 40
//    }
//    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    func configureHierarchy() {
        contentView.addSubview(button)
    }
    
    func configureLayout() {
        button.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        button.layer.cornerRadius = frame.width/2
        clipsToBounds = true
        layer.cornerRadius = frame.width/2
    }
    
}
