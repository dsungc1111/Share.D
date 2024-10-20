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
       
        case birthday
        case food
        case lux
        case test
        case special
        case candle
        case starbucks
        case holi
    }
    
    enum CategoryTitle: String, CaseIterable {
        
        case birthday = "생일"
        case food = "졸업식"
        case lux = "럭셔리"
        case test = "수능"
        case special = "기념일"
        case candle = "집들이"
        case starbucks = "교환권"
        case holi = "명절"
    }
    
    let categoryBtn = {
        let btn = UIButton()
        btn.contentMode = .center
        btn.clipsToBounds = true
        btn.layer.borderWidth = 0.5
        btn.isEnabled = false
        
        
        btn.setTitleColor(UIColor.black, for: .disabled)
        btn.backgroundColor = UIColor.lightGray
        return btn
    }()
    let categoryLabel = {
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
        contentView.addSubview(categoryBtn)
        contentView.addSubview(categoryLabel)
    }
    
    override func configureLayout() {
        categoryBtn.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.centerX.equalTo(contentView.safeAreaLayoutGuide)
            make.size.equalTo(60)
        }
        categoryBtn.layer.cornerRadius = 30
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryBtn.snp.bottom)
            make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    
    func cellConfiguration(item: Int) {
        
        let image = UIImage(named: CategoryLogoImage.allCases[item].rawValue)
        
        categoryBtn.setImage(image, for: .normal)
        categoryBtn.setImage(image, for: .disabled)
        
        categoryLabel.text = CategoryTitle.allCases[item].rawValue
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
