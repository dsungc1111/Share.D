//
//  QuestionView.swift
//  Agewise
//
//  Created by 최대성 on 8/19/24.
//

import UIKit
import SnapKit
import Kingfisher

final class PostView: BaseView {
    
    let imageContainer = {
        let container = UIImageView()
        container.layer.cornerRadius = 10
        container.contentMode = .scaleAspectFit
        return container
    }()
//    let imageButton = {
//        var config = UIButton.Configuration.plain()
//        
//        config.attributedTitle = "이미지"
//        config.image = UIImage(systemName: "plus.circle")
//        config.imagePlacement = .leading
//        config.imagePadding = 10
//        
//        let button = UIButton(configuration: config)
//        return button
//    }()
    
    let infoLabel = {
        let label = UILabel()
        label.text = "제품정보란"
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    let mallnameLabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    let priceLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()
    
    
    let textView = {
        let text = UITextView()
        text.layer.borderWidth = 1
        text.layer.cornerRadius = 10
        text.font = .systemFont(ofSize: 13)
        text.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)
        return text
    }()
    
    let saveButton = {
        let btn = UIButton()
        btn.setTitle("저장", for: .normal)
        btn.backgroundColor = .systemGray
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(imageContainer)
        addSubview(textView)
        addSubview(infoLabel)
        addSubview(mallnameLabel)
        addSubview(saveButton)
        addSubview(priceLabel)
    }
    override func configureLayout() {
        imageContainer.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.equalTo(250)
        }
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(imageContainer.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        mallnameLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(10)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(15)
            make.height.equalTo(200)
        }
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            make.height.equalTo(60)
        }
    }
    
    func configureView(product: ProductDetail) {
        
        let image = URL(string: product.image)
        
        imageContainer.kf.setImage(with: image)
        
        infoLabel.text = product.title.removeHtmlTag
        mallnameLabel.text = product.mallName
        priceLabel.text = (Int(product.lprice)?.formatted() ?? "0") + " 원"
    }
    func editView(result: PostModelToWrite) {
         
//        guard let urlString = result.files?.first else { return }
//        
//        let image = URL(string: urlString)
//        imageContainer.kf.setImage(with: image)
//        infoLabel.text = result.title.removeHtmlTag
//        mallnameLabel.text = result.content1
//        priceLabel.text = (result.price?.formatted() ?? "0") + "원"
//        textView.text = result.content
    }
}
