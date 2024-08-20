//
//  QuestionListVC.swift
//  Agewise
//
//  Created by 최대성 on 8/15/24.
//

import UIKit
import RxSwift
import RxCocoa

final class QuestionListVC: BaseVC {
    
    private let questionListView = QuestionListView()
    
    private let questionListViewModel = QuestionListViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = questionListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: nil)
  
    }
    override func bind() {
        
        let input = QuestionListViewModel.Input(trigger: Observable.just(()), categoryTap: questionListView.categoryCollectionView.rx.modelSelected(String.self))
        
        let output = questionListViewModel.transform(input: input)
        
        
        output.ageList
            .bind(to: questionListView.categoryCollectionView.rx.items(cellIdentifier: ListCategoryCollectionViewCell.identifier, cellType: ListCategoryCollectionViewCell.self)) { row, element, cell in
                print(element)
                cell.categoryButton.setTitle(element, for: .normal)
            }
            .disposed(by: disposeBag)
        
        output.list
            .bind(to: questionListView.resultCollectionView.rx.items(cellIdentifier: QuestionListCollectionViewCell.identifier, cellType: QuestionListCollectionViewCell.self)) { (row, element, cell) in
                
                cell.priceLabel.text = (element.price?.formatted() ?? "0") + " 원"
                cell.titleLabel.text = element.title.removeHtmlTag
                if let image = element.files?.first {
                    let imageUrl = URL(string: image)
                    cell.imageView.kf.setImage(with: imageUrl)
                }
                
            }
            .disposed(by: disposeBag)
        
        
    
    }
    
    
}
