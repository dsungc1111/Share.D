//
//  TrendCollectionViewCell.swift
//  Agewise
//
//  Created by 최대성 on 8/15/24.
//

import UIKit
import RxSwift
import SnapKit

final class RecommendCollectionViewCell: BaseCollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    
    let presentButton = {
        let btn = UIButton()
        btn.titleLabel?.textAlignment = .center
        btn.isEnabled = false
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(presentButton)
    }
    
    override func configureLayout() {
        contentView.backgroundColor = UIColor(hexCode: MainColor.main.rawValue, alpha: 1)
        presentButton.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func configureCell(element: String) {
        presentButton.setTitle(element, for: .normal)
    }
}
