//
//  DTODescriptionBLR.swift
//  Storage
//
//  Created by k.zubar on 3.07.24.
//

import UIKit
import CoreData

public protocol DTODescriptionBLR {
    
    associatedtype MO: MODescriptionBLR
    
    var isGid_0: Bool { get }
    var isGid_1: Bool { get }
    var isGid_2: Bool { get }
    
    
    var latitude:  Double  {get set}
    var longitude:  Double  {get set}
    
    var country:  String?  {get set}
    var engType_1: String?  {get set}
    var engType_2: String?  {get set}
    var gid_0: String?  {get set}
    var gid_1: String?  {get set}
    var gid_2: String?  {get set}
    var hasc_1: String?  {get set}
    var hasc_2: String?  {get set}
    var name_0: String?  {get set}
    var name_1: String?  {get set}
    var name_2: String?  {get set}
    var nl_name_1: String?  {get set}
    var nl_name_2: String?  {get set}
    var type_0: String?  {get set}
    var type_1: String?  {get set}
    var type_2: String?  {get set}
    var varname_1: String?  {get set}
    var varname_2: String?  {get set}
    
    var coordinates: [[Double]]?  {get set}

    static func fromMO(_ mo: MO) -> Self?
    
    func createMO(context: NSManagedObjectContext) -> MO?
    
}

public protocol MODescriptionBLR: NSManagedObject, NSFetchRequestResult {
    
    var gid_0: String? { get }
    var gid_1: String? { get }
    var gid_2: String? { get }

    var latitude:  Double { get }
    var longitude:  Double { get }

    func apply(dto: any DTODescriptionBLR)
    
    func toDTO() -> (any DTODescriptionBLR)?
}

