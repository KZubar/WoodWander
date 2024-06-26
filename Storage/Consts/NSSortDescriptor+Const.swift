//
//  NSSortDescriptor+Const.swift
//  Storage
//
//  Created by k.zubar on 26.06.24.
//

import Foundation
import CoreData

public extension NSSortDescriptor {
    
    enum Notification {
        public static var byDate: NSSortDescriptor {
            let dateKeypath = #keyPath(BasePointMO.date)
            return .init(key: dateKeypath, ascending: false)
        }
        
        public static var byName: NSSortDescriptor {
            let nameKeypath = #keyPath(BasePointMO.name)
            return .init(key: nameKeypath, ascending: false)
        }
        
    }
}
