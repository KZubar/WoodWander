//
//  ParametersHelper.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit

final class ParametersHelper {
    
    enum ParameterKey: String {
        case authenticated
        case onboarded
        
        case email
        case emailVerified
        case displayName
        case photoURL
        case uid
    }

    private static var ud: UserDefaults = .standard
    
    private init() {} //закрываем private, что бы ни кто не мог создать
    
    static func set(_ key: ParameterKey, value: Bool) {
        ud.setValue(value, forKey: key.rawValue)
    }
    
    static func set(_ key: ParameterKey, value: String) {
        ud.setValue(value, forKey: key.rawValue)
    }
    
    static func set(_ key: ParameterKey, value: Int) {
        ud.setValue(value, forKey: key.rawValue)
    }

    
    static func get(_ key: ParameterKey) -> Bool {
        return ud.bool(forKey: key.rawValue)
    }
    
    static func get(_ key: ParameterKey) -> String {
        return ud.string(forKey: key.rawValue) ?? ""
    }
    
    static func get(_ key: ParameterKey) -> Int {
        return ud.integer(forKey: key.rawValue)
    }
}
