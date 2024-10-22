//
//  MainVC.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast
import Kingfisher
import Alamofire


final class PromotionVC: BaseVC {
    
    private let promotionView = PromotionView()
    
    private let promotionViewModel = PromotionVM()
    
    private let disposeBag = DisposeBag()
    
    private var showToast: (() -> Void)?
    
    override func loadView() {
        view = promotionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    override func bind() {
        
        let input = PromotionVM.Input(adTrigger: Observable.just(()), searchText: promotionView.searchBar.rx.text.orEmpty, searchButtonTap: promotionView.searchBar.rx.searchButtonClicked)
        let output = promotionViewModel.transform(input: input)
        
        
        
        output.categoryList
            .bind(to: promotionView.categoryCollectionView.rx.items(cellIdentifier: CategoryCollectionViewCell.identifier, cellType: CategoryCollectionViewCell.self)) { (row, element, cell) in
                
                cell.cellConfiguration(item: row)
            }
            .disposed(by: disposeBag)
        
        output.adList
            .bind(to: promotionView.itemCollectionView.rx.items(cellIdentifier: AdCollectionViewCell.identifier, cellType: AdCollectionViewCell.self)) { (row, element, cell) in
                
                cell.configureCell(element: element, item: row)
            }
            .disposed(by: disposeBag)
        
        output.logout
            .bind(with: self) { owner, result in
                print("로그인 만료임!!!!!")
                owner.logoutUser()
            }
            .disposed(by: disposeBag)
        
        output.profileImage
            .bind(with: self) { owner, value in
                
                let url = APIKey.baseURL + "v1/" + value
                
                let header: HTTPHeaders = [
                    APIKey.HTTPHeaderName.authorization.rawValue: UserDefaultManager.accessToken,
                    APIKey.HTTPHeaderName.sesacKey.rawValue: APIKey.DeveloperKey,
                ]
                
                DispatchQueue.global().async {
                    AF.request(url, method: .get, headers: header)
                        .validate(statusCode: 200..<300)
                        .responseData { response in
                            
                            switch response.result {
                            case .success(let data):
                                
                                if let profileImage = UIImage(data: data) {
                                    let resizedImage = owner.resizeImage(image: profileImage, targetSize: CGSize(width: 50, height: 50))
                                    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
                                    let roundedImage = renderer.image { _ in
                                        let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
                                        path.addClip()
                                        resizedImage.draw(in: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
                                    }
                                    
                                    let originalImage = roundedImage.withRenderingMode(.alwaysOriginal)
                                    let title = "Hello, \(UserDefaultManager.userNickname) 님"
                                    
                                    let profileBarButtonItem = UIBarButtonItem(image: originalImage, style: .plain, target: nil, action: nil)
                                    
                                    
                                    DispatchQueue.main.async {
                                        owner.navigationItem.leftBarButtonItems = [profileBarButtonItem, UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)]
                                    }
                                    
                                } else {
                                    print("이미지 변환 실패")
                                }
                                
                            case .failure(let error):
                                print("이미지 다운로드 실패: \(error)")
                            }
                        }
                }
                
            }
            .disposed(by: disposeBag)
        
        output.searchText
            .bind(with: self) { owner, searchText in
                let vc = ProductVC()
                vc.navigationItem.title = searchText
                vc.searchItem = searchText
                
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        promotionView.promotionView.rx.tap
            .bind(with: self) { owner, _ in
                let vc = ProductVC()
                vc.navigationItem.title = "파격 특가"
                vc.searchItem = "특가"
                
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        promotionView.categoryCollectionView.rx.modelSelected(String.self)
            .bind(with: self) { owner, category in
                
                let vc = ProductVC()
                vc.navigationItem.title = category
                vc.searchItem = category
                
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        promotionView.moreBtn.rx.tap
            .bind(with: self) { owner, _ in
                let vc = ProductVC()
                vc.navigationItem.title = "요즘 인기"
                vc.searchItem = "집들이 선물"
                
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
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
    
    func fetchProfileImage(value: String) -> Single<Data> {
        return Single.create { single in
            let url = APIKey.baseURL + "v1/" + value
            
            let header: HTTPHeaders = [
                APIKey.HTTPHeaderName.authorization.rawValue: UserDefaultManager.accessToken,
                APIKey.HTTPHeaderName.sesacKey.rawValue: APIKey.DeveloperKey,
            ]
            
            let request = AF.request(url, method: .get, headers: header)
                .validate(statusCode: 200..<300)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        single(.success(data))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func configureNavigationBar(owner: UIViewController) {
        
        
        fetchProfileImage(value: "profileImageURL")
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: {  data in
                if let profileImage = UIImage(data: data) {
                    
                    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20))
                    let roundedImage = renderer.image { _ in
                        let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
                        path.addClip()
                        profileImage.draw(in: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
                    }
                    
                    let originalImage = roundedImage.withRenderingMode(.alwaysOriginal)
                    let title = "Hello, \(UserDefaultManager.userNickname) 님"
                    
                    let profileBarButtonItem = UIBarButtonItem(image: originalImage, style: .plain, target: nil, action: nil)
                    
                    owner.navigationItem.leftBarButtonItems = [profileBarButtonItem, UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)]
                } else {
                    print("이미지 변환 실패")
                }
            }, onFailure: { error in
                print("이미지 다운로드 실패: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    
    
}






