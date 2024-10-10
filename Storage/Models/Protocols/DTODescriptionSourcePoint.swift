//
//  DTODescriptionSourcePoint.swift
//  Storage
//
//  Created by k.zubar on 1.10.24.
//

import UIKit
import CoreData

public protocol DTODescriptionSourcePoint {
    
    associatedtype MO: MODescriptionSourcePoint
    
    var descr: String?  {get set}
    var name: String?  {get set}
    var uuid: String  {get set}
    
    static func fromMO(_ mo: MO) -> Self?
    
    func createMO(context: NSManagedObjectContext) -> MO?
    
}

public protocol MODescriptionSourcePoint: NSManagedObject, NSFetchRequestResult {
    
    var uuid: String? { get }
     
    func apply(dto: any DTODescriptionSourcePoint)
    
    func toDTO() -> (any DTODescriptionSourcePoint)?
}
