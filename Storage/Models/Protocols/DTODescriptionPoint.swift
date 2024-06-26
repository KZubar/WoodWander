//
//  DTODescription.swift
//  Storage
//
//  Created by k.zubar on 26.06.24.
//

import UIKit
import CoreData

public protocol DTODescriptionPoint {
    
    associatedtype MO: MODescriptionPoint
    
    var uuid:  String  {get set}
    var date:  Date?  {get set}
    var latitude: Double  {get set}
    var longitude: Double  {get set}
    var descr: String?  {get set}
    var name: String?  {get set}
    var isDisabled: Bool  {get set}

    static func fromMO(_ mo: MO) -> Self?
    
    func createMO(context: NSManagedObjectContext) -> MO?
    
}

public protocol MODescriptionPoint: NSManagedObject, NSFetchRequestResult {
    
    var uuid: String? { get }
     
    func apply(dto: any DTODescriptionPoint)
    
    func toDTO() -> (any DTODescriptionPoint)?
}

