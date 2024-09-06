//
//  EditUserVM.swift
//  Agewise
//
//  Created by 최대성 on 9/1/24.
//

import Foundation
import RxSwift
import RxCocoa


final class EditUserVM {
    
    struct Input {
        let photoPickTap: ControlEvent<Void>
        let nick: ControlProperty<String>
        let profile: BehaviorRelay<Data?>
        let editTap: ControlEvent<Void>
    }
    struct Output {
        let photoPickTap: ControlEvent<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    
    
    func transform(input: Input) -> Output {
        
        var nick = ""
        
        input.nick
            .bind(with: self) { owner, value in
                print(value)
                nick = value
            }
            .disposed(by: disposeBag)
//        
//        input.profile
//            .map { data in
//                let data = EditProfile(nick: nick, profile: data ?? Data())
//                return data
//            }
//            .flatMap { query in
//                UserNetworkManager.shared.userNetwork(api: .edit(query: query), model: EditProfileModel.self)
//            }
//            .bind(with: self) { owner, result in
//                
//                    print("수정 겨로가", result)
//            
//                
//            }
//            .disposed(by: disposeBag)
        
        
        input.profile
            .bind(with: self) { owner, data in
                print(data)
            }
            .disposed(by: disposeBag)
        
        
        input.editTap
            .withLatestFrom(input.profile)
            .map { data in
                let data = EditProfile(nick: nick, profile: data ?? Data())
                print("프로필", data.profile)
                return data
            }
            .flatMap { query in
                UserNetworkManager.shared.userUploadNetwork(api: .edit(query: query), model: EditProfileModel.self)
            }
            .bind(with: self) { owner, result in
                
                    print("수정 겨로가", result)
                UserDefaultManager.userNickname = result.data?.nick ?? ""
                UserDefaultManager.profileImage = result.data?.profileImage ?? ""
                
            }
            .disposed(by: disposeBag)
        
        
        return Output(photoPickTap: input.photoPickTap)
    }
}
