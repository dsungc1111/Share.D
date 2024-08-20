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
}
