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
    
    let imageview = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    let contentLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 35)
        label.textColor = .white
        return label
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
        contentView.addSubview(imageview)
        contentView.addSubview(contentLabel)
    }
    
    override func configureLayout() {
        imageview.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(50)
        }
    }
    
    func configureCell(element: String, image: UIImage?) {
        
        imageview.image = image
        
        contentLabel.text = element
    }
}
