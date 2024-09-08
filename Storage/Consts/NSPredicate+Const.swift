//
//  NSPredicate+Const.swift
//  Storage
//
//  Created by k.zubar on 26.06.24.
//

import CoreData

public extension NSPredicate {
    
    enum Point {
        
        public static var all: NSPredicate {
            let completedDateKeypath = #keyPath(PlanPointMO.uuid)
            return .init(format: "NOT \(completedDateKeypath) == NULL")
        }
        
        public static func point(byUuid uuid: String) -> NSPredicate {
            let uuidKeypath = "\(#keyPath(PlanPointMO.uuid))"
            return .init(format: "\(uuidKeypath) CONTAINS[cd] %@", uuid)
        }
        
        public static func points(in uuids: [String]) -> NSPredicate {
            let uuidKeypath = "\(#keyPath(PlanPointMO.uuid))"
            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                .init(format: "\(uuidKeypath) IN %@", uuids),
                all
            ])
        }
        
    }
    
    enum PPCategories {
        
        public static var all: NSPredicate {
            let uuidPointKeypath = "\(#keyPath(PPCategoriesMO.uuidPoint))"
            let uuidCategoryKeypath = "\(#keyPath(PPCategoriesMO.uuidCategory))"
            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                .init(format: "NOT \(uuidPointKeypath) == NULL", uuidPointKeypath),
                .init(format: "NOT \(uuidCategoryKeypath) == NULL", uuidCategoryKeypath)
            ])
        }

        public static func point(byUuidPoin uuidPoint: String,
                                 byUuidCategory uuidCategory: String) -> NSPredicate {
            let uuidPointKeypath = "\(#keyPath(PPCategoriesMO.uuidPoint))"
            let uuidCategoryKeypath = "\(#keyPath(PPCategoriesMO.uuidCategory))"
            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                .init(format: "\(uuidPointKeypath) CONTAINS[cd] %@", uuidPoint),
                .init(format: "\(uuidCategoryKeypath) CONTAINS[cd] %@", uuidCategory)
            ])
        }

        public static func categories(byUuidPoin uuidPoint: String) -> NSPredicate {
            let uuidPointKeypath = "\(#keyPath(PPCategoriesMO.uuidPoint))"
            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                .init(format: "\(uuidPointKeypath) CONTAINS[cd] %@", uuidPoint)
            ])
        }

    }

    enum CategoriesPoint {
        
        public static var all: NSPredicate {
            let uuidKeypath = #keyPath(CategoriesPointMO.uuid)
            return .init(format: "NOT \(uuidKeypath) == NULL")
        }
        
        public static func category(byUuid uuid: String) -> NSPredicate {
            let uuidKeypath = "\(#keyPath(CategoriesPointMO.uuid))"
            return .init(format: "\(uuidKeypath) CONTAINS[cd] %@", uuid)
        }
        
        public static func categories(in uuids: [String]) -> NSPredicate {
            let uuidKeypath = "\(#keyPath(CategoriesPointMO.uuid))"
            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                .init(format: "\(uuidKeypath) IN %@", uuids),
                all
            ])
        }
        
    }

}
