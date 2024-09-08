//
//  PostDetailView.swift
//  Agewise
//
//  Created by 최대성 on 8/21/24.
//

import UIKit
import SnapKit
import Kingfisher
import Alamofire

final class PostDetailView: BaseView {
    
    private let dateTool = ReuseDateformatter.shared
    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    let contentLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    let profileImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 25
        return view
    }()
    let writerLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    let dateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    let productLabel = {
        let label = UILabel()
        label.text = "제목 테이블 예비"
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    let commentButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        btn.tintColor = UIColor(hexCode: MainColor.main.rawValue, alpha: 1)
        btn.setTitleColor(UIColor(hexCode: MainColor.main.rawValue, alpha: 1), for: .normal)
        return btn
    }()
    let likeButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.tintColor = UIColor(hexCode: MainColor.main.rawValue, alpha: 1)
        btn.setTitleColor(UIColor(hexCode: MainColor.main.rawValue, alpha: 1), for: .normal)
        return btn
    }()
    let bookmarkButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "basket"), for: .normal)
        btn.tintColor = UIColor(hexCode: MainColor.main.rawValue, alpha: 1)
        btn.setTitleColor(UIColor(hexCode: MainColor.main.rawValue, alpha: 1), for: .normal)
        return btn
    }()
    let textField = {
        let text = UITextField()
        text.placeholder = "댓글을 입력하세요."
        text.borderStyle = .roundedRect
        return text
    }()
    
    let buyButton = {
        let btn = UIButton()
        btn.setTitle("구매하기", for: .normal)
        btn.backgroundColor = UIColor(hexCode: MainColor.main.rawValue, alpha: 1)
        btn.layer.cornerRadius = 10
        return btn
    }()
    let devider = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    //    let editButton = {
    //        let btn = UIButton()
    //        btn.setTitle("수정", for: .normal)
    //        btn.setTitleColor(.red, for: .normal)
    //        btn.backgroundColor = .white
    //        btn.layer.borderWidth = 1
    //        btn.layer.borderColor = UIColor.red.cgColor
    //        return btn
    //    }()
    //    let deleteButton = {
    //        let btn = UIButton()
    //        btn.setTitle("삭제", for: .normal)
    //        btn.setTitleColor(.red, for: .normal)
    //        btn.backgroundColor = .white
    //        btn.layer.borderWidth = 1
    //        btn.layer.borderColor = UIColor.red.cgColor
    //        return btn
    //    }()
    
    override func configureHierarchy() {
        addSubview(imageView)
        addSubview(profileImageView)
        addSubview(writerLabel)
        addSubview(dateLabel)
        addSubview(contentLabel)
        addSubview(productLabel)
        addSubview(commentButton)
        addSubview(likeButton)
        addSubview(bookmarkButton)
        addSubview(buyButton)
        addSubview(devider)
        //        addSubview(textField)
    }
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(330)
        }
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.trailing.equalTo(bookmarkButton.snp.leading).offset(-10)
            make.height.equalTo(40)
        }
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.trailing.equalTo(likeButton.snp.leading).offset(-10)
            make.height.equalTo(40)
        }
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(commentButton.snp.bottom).offset(5)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.size.equalTo(50)
        }
        devider.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(1)
        }
        profileImageView.backgroundColor = .lightGray
        writerLabel.snp.makeConstraints { make in
            //            make.top.equalTo(commentButton.snp.bottom).offset(5)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            //            make.height.equalTo(40)
            make.centerY.equalTo(profileImageView)
        }
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.centerY.equalTo(profileImageView)
        }
        productLabel.snp.makeConstraints { make in
            make.top.equalTo(devider.snp.bottom).offset(15)
            make.leading.equalTo(safeAreaLayoutGuide).inset(25)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(40)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(productLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(25)
        }
        buyButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(50)
            make.height.equalTo(50)
        }
        //        editButton.snp.makeConstraints { make in
        //            make.centerX.equalTo(safeAreaLayoutGuide)
        //            make.bottom.equalTo(safeAreaLayoutGuide).inset(50)
        //            make.width.equalTo(100)
        //            make.height.equalTo(40)
        //        }
        //        deleteButton.snp.makeConstraints { make in
        //            make.centerX.equalTo(safeAreaLayoutGuide)
        //            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        //            make.width.equalTo(100)
        //            make.height.equalTo(40)
        //        }
    }
    
    func configurePostDetail(element: PostModelToWrite) {
        
        let date = Date()
        
        guard let url = element.files?.first else { return }
        let image = URL(string: url)
        imageView.kf.setImage(with: image)
        
        writerLabel.text = element.creator.nick
        dateLabel.text = dateTool.messageTime(dateString: element.createdAt, currentDate: date)
        contentLabel.text = element.content
        productLabel.text = element.title.removeHtmlTag
        
        
        if let like = element.likes {
            let likeCount = like.count
            likeButton.setTitle(likeCount.formatted(), for: .normal)
            if like.contains(UserDefaultManager.userId) {
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            
        }
        // element.content1 > 몰 이름
        
        let commentCount = element.comments?.count ?? 0
        commentButton.setTitle(commentCount.formatted(), for: .normal)
        
        let bookmarkCount = element.likes2?.count ?? 0
        bookmarkButton.setTitle(bookmarkCount.formatted(), for: .normal)
        
        
        //        element.creator
        //        element.creator.profileImage
        
        
        let profileURL = element.creator.profileImage ?? ""
        
        
        UserNetworkManager.shared.fetchProfileImage(imageURL: profileURL) { [weak self] data in
            guard let data = data else { return }
            if let profileImage = UIImage(data: data) {
                
                let resizedImage = self?.resizeImage(image: profileImage, targetSize: CGSize(width: 50, height: 50))
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
                let roundedImage = renderer.image { _ in
                    let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
                    path.addClip()
                    resizedImage?.draw(in: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
                }
                let originalImage = roundedImage.withRenderingMode(.alwaysOriginal)
                self?.profileImageView.image = originalImage
            }
            
            
        }
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

