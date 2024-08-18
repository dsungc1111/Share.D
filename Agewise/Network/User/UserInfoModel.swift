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
struct EmailValidationModel: Decodable {
    let message: String
}
struct LoginModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let accessToken: String
    let refreshToken: String
}
struct RefreshModel: Decodable {
    let accessToken: String
}
struct ProfileModel: Decodable {
    let id: String
    let email: String
    let nick: String
    
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case email
        case nick
    }
}


struct LoginQuery: Encodable {
    let email: String
    let password: String
}
struct JoinQuery: Encodable {
    let email: String
    let password: String
    let nick: String
}
struct EmailValidationQuery: Encodable {
    let email: String
}
