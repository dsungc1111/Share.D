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
    
    let presentButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.textAlignment = .center
        return btn
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
        contentView.addSubview(presentButton)
    }
    
    func configureLayout() {
        presentButton.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
}
