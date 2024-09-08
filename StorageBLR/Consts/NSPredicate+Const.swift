//
//  NSPredicate+Const.swift
//  StorageBLR
//
//  Created by k.zubar on 4.07.24.
//

import CoreData

public extension NSPredicate {
    
    enum BlrCoordinate {
        
        public static func byBLR(in blr: BlrMO) -> NSPredicate {
            let keypath = "\(#keyPath(BlrCoordinateMO.blr))"
            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                .init(format: "\(keypath) == %@", blr)
            ])
        }
        
    }
    
    enum BLR {

        //MARK: - all
        public static var all: NSPredicate {
            let completedDateKeypath = #keyPath(BlrMO.gid_0)
            return .init(format: "NOT \(completedDateKeypath) == NULL")
        }
        public static var all0: NSPredicate {
            let completedDateKeypath0 = "\(#keyPath(BlrMO.gid_0))"
            let completedDateKeypath1 = "\(#keyPath(BlrMO.gid_1))"
            let completedDateKeypath2 = "\(#keyPath(BlrMO.gid_2))"

            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                .init(format: "NOT \(completedDateKeypath0) == NULL"),
                .init(format: "\(completedDateKeypath1) == NULL"),
                .init(format: "\(completedDateKeypath2) == NULL"),
            ])
        }
        public static var all1: NSPredicate {
            let completedDateKeypath0 = "\(#keyPath(BlrMO.gid_0))"
            let completedDateKeypath1 = "\(#keyPath(BlrMO.gid_1))"
            let completedDateKeypath2 = "\(#keyPath(BlrMO.gid_2))"

            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                .init(format: "NOT \(completedDateKeypath0) == NULL"),
                .init(format: "NOT \(completedDateKeypath1) == NULL"),
                .init(format: "\(completedDateKeypath2) == NULL"),
            ])
        }
        public static var all2: NSPredicate {
            let completedDateKeypath0 = "\(#keyPath(BlrMO.gid_0))"
            let completedDateKeypath1 = "\(#keyPath(BlrMO.gid_1))"
            let completedDateKeypath2 = "\(#keyPath(BlrMO.gid_2))"

            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                .init(format: "NOT \(completedDateKeypath0) == NULL"),
                .init(format: "NOT \(completedDateKeypath1) == NULL"),
                .init(format: "NOT \(completedDateKeypath2) == NULL"),
            ])
        }

        //MARK: - blr
        public static func blr0(byId uuid: String) -> NSPredicate {
            let uuidKeypath = "\(#keyPath(BlrMO.gid_0))"
            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                .init(format: "\(uuidKeypath) CONTAINS[cd] %@", uuid),
                all0
            ])
        }
        
        public static func blr1(byId uuid: String) -> NSPredicate {
            let uuidKeypath = "\(#keyPath(BlrMO.gid_1))"
            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                .init(format: "\(uuidKeypath) CONTAINS[cd] %@", uuid),
                all1
            ])
        }
        
        public static func blr2(byId uuid: String) -> NSPredicate {
            let uuidKeypath = "\(#keyPath(BlrMO.gid_2))"
            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                .init(format: "\(uuidKeypath) CONTAINS[cd] %@", uuid),
                all2
            ])
        }

        //MARK: - blrs
        public static func blr0s(in uuids: [String]) -> NSPredicate {
            let uuidKeypath = "\(#keyPath(BlrMO.gid_0))"
            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                .init(format: "\(uuidKeypath) IN %@", uuids),
                all0
            ])
        }
        public static func blr1s(in uuids: [String]) -> NSPredicate {
            let uuidKeypath = "\(#keyPath(BlrMO.gid_1))"
            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                .init(format: "\(uuidKeypath) IN %@", uuids),
                all1
            ])
        }
        public static func blr2s(in uuids: [String]) -> NSPredicate {
            let uuidKeypath = "\(#keyPath(BlrMO.gid_2))"
            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                .init(format: "\(uuidKeypath) IN %@", uuids),
                all2
            ])
        }

    }
    
}
