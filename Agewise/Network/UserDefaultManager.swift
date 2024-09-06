//
//  UserDefaultManager.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.string(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}

final class UserDefaultManager {
    
    private enum UserDefaultKey: String {
        case access
        case refresh
        case userNickname
        case userId
        case profile
    }
    
    
    static let shared = UserDefaultManager()
    
    private init() {}
    
    @UserDefault(key: UserDefaultKey.access.rawValue, defaultValue: "")
    static var accessToken
    
    @UserDefault(key: UserDefaultKey.refresh.rawValue, defaultValue: "")
    static var refreshToken
    
    @UserDefault(key: UserDefaultKey.userNickname.rawValue, defaultValue: "")
    static var userNickname
    
    @UserDefault(key: UserDefaultKey.userId.rawValue, defaultValue: "")
    static var userId
    
    @UserDefault(key: UserDefaultKey.profile.rawValue, defaultValue: "")
    static var profileImage
}




//final class UserDefaultManager {
//
//    private enum UserDefaultKey: String {
//        case access
//        case refresh
//        case userNickname
//        case userId
//        case profile
//    }
//    
//    
//    static let shared = UserDefaultManager()
//    
//    private init() {}
//    
//    
//    var accessToken: String {
//        get {
//            UserDefaults.standard.string(forKey: UserDefaultKey.access.rawValue) ?? ""
//        }
//        set {
//            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey.access.rawValue)
//        }
//    }
//    var refreshToken: String {
//        get {
//            UserDefaults.standard.string(forKey: UserDefaultKey.refresh.rawValue) ?? ""
//        }
//        set {
//            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey.refresh.rawValue)
//        }
//    }
//    
//    var userNickname: String {
//        get {
//            UserDefaults.standard.string(forKey: UserDefaultKey.userNickname.rawValue) ?? ""
//        }
//        set {
//            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey.userNickname.rawValue)
//        }
//    }
//    
//    var userId: String {
//        get {
//            UserDefaults.standard.string(forKey: UserDefaultKey.userId.rawValue) ?? ""
//        }
//        set {
//            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey.userId.rawValue)
//        }
//    }
//    var profileImage: String {
//        get {
//            UserDefaults.standard.string(forKey: UserDefaultKey.profile.rawValue) ?? ""
//        }
//        set {
//            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey.profile.rawValue)
//        }
//    }
//    
//    func removeAll() {
//        for key in UserDefaults.standard.dictionaryRepresentation().keys {
//            UserDefaults.standard.removeObject(forKey: key.description)
//        }
//    }
//}
