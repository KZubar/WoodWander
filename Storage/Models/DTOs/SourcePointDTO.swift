//
//  SourcePointDTO.swift
//  Storage
//
//  Created by k.zubar on 1.10.24.
//

import Foundation
import CoreData

public struct SourcePointDTO: DTODescriptionSourcePoint {
    
    public typealias MO = SourcePointMO

    public var descr: String?
    public var name: String?
    public var uuid: String

    public init(descr: String?, name: String?, uuid: String) {
        self.descr = descr
        self.name = name
        self.uuid = uuid
    }

    public init() {
        self.descr = ""
        self.name = ""
        self.uuid = UUID().uuidString
    }

    public static func fromMO(_ mo: SourcePointMO) -> SourcePointDTO? {
        guard
            let descr = mo.descr,
            let name = mo.name,
            let uuid = mo.uuid
        else { return nil }
        
        return SourcePointDTO(descr: descr,
                              name: name,
                              uuid: uuid)
    }
    
    public func createMO(context: NSManagedObjectContext) -> SourcePointMO? {
        let mo = SourcePointMO(context: context)
        mo.apply(dto: self)
        return mo
    }

}


extension SourcePointDTO: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    public static func == (lhs: SourcePointDTO, rhs: SourcePointDTO) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
