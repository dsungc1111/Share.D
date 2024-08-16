//
//  TrendCollectionViewCell.swift
//  Agewise
//
//  Created by 최대성 on 8/15/24.
//

import UIKit
import RxSwift
import SnapKit

final class TrendCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    let presentLabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
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
        contentView.addSubview(presentLabel)
    }
    
    func configureLayout() {
        presentLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
}
