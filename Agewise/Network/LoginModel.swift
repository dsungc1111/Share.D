//
//  LoginModel.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import Foundation

struct JoinModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
}

struct LoginModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profile: String?
    let accessToken: String
    let refreshToken: String
    
}
