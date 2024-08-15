//
//  UserDefaultManager.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import Foundation

final class UserDefaultManager {

    private enum UserDaefaultKey: String {
        case access
        case refrech
    }
    
    static let shared = UserDefaultManager()
    
    private init() {}
    
    var accessToken: String {
        get {
            UserDefaults.standard.string(forKey: UserDaefaultKey.access.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDaefaultKey.access.rawValue)
        }
    }
    var refreshToken: String {
        get {
            UserDefaults.standard.string(forKey: UserDaefaultKey.refrech.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDaefaultKey.refrech.rawValue)
        }
    }
}
