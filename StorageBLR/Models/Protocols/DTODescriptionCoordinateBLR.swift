//
//  DTODescriptionCoordinateBLR.swift
//  StorageBLR
//
//  Created by k.zubar on 6.07.24.
//

import UIKit
import CoreData

public protocol DTODescriptionCoordinateBLR {
    
    associatedtype MO: MODescriptionCoordinateBLR
    
    var latitude:   Double  {get set}
    var longitude:  Double  {get set}
    
    var blr: BlrDTO?  {get set}

    static func fromMO(_ mo: MO) -> Self?
    
    func createMO(context: NSManagedObjectContext) -> MO?
    
}

public protocol MODescriptionCoordinateBLR: NSManagedObject, NSFetchRequestResult {
    
    func apply(dto: any DTODescriptionCoordinateBLR)
    
    func toDTO() -> (any DTODescriptionCoordinateBLR)?
}

