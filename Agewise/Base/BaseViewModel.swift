//
//  BaseViewModel.swift
//  Agewise
//
//  Created by 최대성 on 8/15/24.
//

import Foundation


class BaseViewModel {
    
    
    func judgeStatusCode(statusCode: Int, title: String) -> String {
        
        switch statusCode {
        case 420 :
            return "SesacKey를 확인하세요"
        case 429:
            return "과호출입니다!"
        case 444:
            return "비정상적인 URL입니다!"
        default:
            return "기타 에러 - 사전 정의 X"
        }
    }
}
