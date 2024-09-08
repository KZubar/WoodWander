//
//  DTODescriptionPPCategories.swift
//  Storage
//
//  Created by k.zubar on 1.09.24.
//

import UIKit
import CoreData

public protocol DTODescriptionPPCategories {
    
    associatedtype MO: MODescriptionPPCategories
    
    var uuidPoint:  String  {get set}
    var uuidCategory:  String  {get set}
    var descr: String?  {get set}
    var isUsed: Bool  {get set}

    static func fromMO(_ mo: MO) -> Self?
    
    func createMO(context: NSManagedObjectContext) -> MO?
    
}

public protocol MODescriptionPPCategories: NSManagedObject, NSFetchRequestResult {
    
    var uuidPoint: String? { get }
    var uuidCategory: String? { get }
    var isUsed: Bool  {get set}

    func apply(dto: any DTODescriptionPPCategories)
    
    func toDTO() -> (any DTODescriptionPPCategories)?
}

