//
//  Container.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import Foundation
//FIXME: - add later: import Storage

final class Container {
    
    private var container: [String: Any] = [:]
    private var lazyContainer: [String: () -> Any] = [:]

    func register<Type: Any>(_ initializer: @escaping () -> Type) {
        lazyContainer["\(Type.self)"] = initializer
    }

    func resolve<Type: Any>() -> Type {
        if let cache = container["\(Type.self)"] as? Type {
            return cache
        }
        
        let new = lazyContainer["\(Type.self)"]?() as! Type
        container["\(Type.self)"] = new
        return new
    }
}
