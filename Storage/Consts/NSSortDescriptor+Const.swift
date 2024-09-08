//
//  NSSortDescriptor+Const.swift
//  Storage
//
//  Created by k.zubar on 26.06.24.
//

import Foundation
import CoreData

public extension NSSortDescriptor {
    
    enum Point {
        public static var byDate: NSSortDescriptor {
            let dateKeypath = #keyPath(PlanPointMO.date)
            return .init(key: dateKeypath, ascending: false)
        }
        
        public static var byName: NSSortDescriptor {
            let nameKeypath = #keyPath(PlanPointMO.name)
            return .init(key: nameKeypath, ascending: false)
        }
        
    }
    
    enum CategoriesPoint {
        public static var byDate: NSSortDescriptor {
            let keypath = #keyPath(CategoriesPointMO.date)
            return .init(key: keypath, ascending: false)
        }
        
        public static var byName: NSSortDescriptor {
            let keypath = #keyPath(CategoriesPointMO.name)
            return .init(key: keypath, ascending: false)
        }
        
        public static var byPredefined: NSSortDescriptor {
            let keypath = #keyPath(CategoriesPointMO.predefined)
            return .init(key: keypath, ascending: true)
        }
        
        public static var byIsDisabled: NSSortDescriptor {
            let keypath = #keyPath(CategoriesPointMO.isDisabled)
            return .init(key: keypath, ascending: false)
        }

    }
    
    
    enum PPCategories {
        public static var byUuidCategory: NSSortDescriptor {
            let keypath = #keyPath(PPCategoriesMO.uuidCategory)
            return .init(key: keypath, ascending: false)
        }
        public static var byUuidPoint: NSSortDescriptor {
            let keypath = #keyPath(PPCategoriesMO.uuidPoint)
            return .init(key: keypath, ascending: false)
        }


    }
}
