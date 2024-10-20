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
        case 403:
            return  "접근권한이 없습니다."
        case 418:
            return "로그인 만료되었습니다. 로그인화면으로 이동합니다."
        case 419:
            return  "다시 실행해주세요"
        case 420 :
            return "개발자 접근 Key를 확인하세요"
        default:
            return "다시 시도해주세요."
        }
    }
}
