//
//  UserDefaultManager.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import Foundation

final class UserDefaultManager {

    private enum UserDefaultKey: String {
        case access
        case refresh
        case userNickname
        case userId
    }
    
    static let shared = UserDefaultManager()
    
    private init() {}
    
    var accessToken: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKey.access.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey.access.rawValue)
        }
    }
    var refreshToken: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKey.refresh.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey.refresh.rawValue)
        }
    }
    
    var userNickname: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKey.userNickname.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey.userNickname.rawValue)
        }
    }
    
    var userId: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKey.userId.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey.userId.rawValue)
        }
    }
    
    func removeAll() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}
