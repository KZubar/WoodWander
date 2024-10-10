//
//  DTODescriptionPPSource.swift
//  Storage
//
//  Created by k.zubar on 1.10.24.
//

import UIKit
import CoreData

public protocol DTODescriptionPPSource {
    
    associatedtype MO: MODescriptionPPSource
    
    var uuidPoint:  String  {get set}
    var uuidSource:  String  {get set}

    static func fromMO(_ mo: MO) -> Self?
    
    func createMO(context: NSManagedObjectContext) -> MO?
    
}

public protocol MODescriptionPPSource: NSManagedObject, NSFetchRequestResult {
    
    var uuidPoint: String? { get }
    var uuidSource: String? { get }

    func apply(dto: any DTODescriptionPPSource)
    
    func toDTO() -> (any DTODescriptionPPSource)?
}

