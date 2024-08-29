//
//  SettingDetailVM.swift
//  Agewise
//
//  Created by 최대성 on 8/29/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingDetailVM {
    
    
    struct Input {
        let list: Observable<[PostModelToWrite]>
        let selectTap: ControlEvent<()>
    }
    
    struct Output {
        let list: Observable<[PostModelToWrite]>
        let rightTitle: PublishSubject<String>
    }
    
    private var disposeBag = DisposeBag()
    private var selectOrDelete = false
    
    
    func transform(input: Input) -> Output {
      
        let rightTitle = PublishSubject<String>()
        
        
        input.selectTap
            .bind(with: self) { owner, _ in
                owner.selectOrDelete.toggle()
                
                if owner.selectOrDelete {
                    rightTitle.onNext("삭제")
                } else {
                    rightTitle.onNext("선택")
                }
                
            }
            .disposed(by: disposeBag)
        
        
        return Output(list: input.list, rightTitle: rightTitle)
    }
    
}
