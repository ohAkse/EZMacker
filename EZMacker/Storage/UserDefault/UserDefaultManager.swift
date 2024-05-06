//
//  UserDefaultManager.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import Foundation
// MARK: - SwiftUI에서는 @AppStorage를 주로 사용하지만, UI와 관련된 내용은 @AppStoragem, UI와 관련없으나 사용여부를 결정짓는것은 UserDefaults로 목적을 구분짓게 하기 위해 사용
@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    let storage: UserDefaults
    
    var wrappedValue: T {
        get { self.storage.object(forKey: self.key) as? T ?? self.defaultValue }
        set { self.storage.set(newValue, forKey: self.key) }
    }
    
    init(key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
}

struct UserDefaultManager {
    //사용 예제
    @UserDefault(key: "name", defaultValue: "")
    static var name: String
}
