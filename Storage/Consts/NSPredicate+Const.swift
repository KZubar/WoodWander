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
            let completedDateKeypath = #keyPath(BasePointMO.uuid)
            return .init(format: "NOT \(completedDateKeypath) == NULL")
        }
        
        public static func point(byUuid uuid: String) -> NSPredicate {
            let uuidKeypath = "\(#keyPath(BasePointMO.uuid))"
            return .init(format: "\(uuidKeypath) CONTAINS[cd] %@", uuid)
        }
        
        public static func points(in uuids: [String]) -> NSPredicate {
            let uuidKeypath = "\(#keyPath(BasePointMO.uuid))"
            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                .init(format: "\(uuidKeypath) IN %@", uuids),
                all
            ])
        }
        
    }
    
}
