//
//  DTODescriptionCategoriesPoint.swift
//  Storage
//
//  Created by k.zubar on 21.08.24.
//

import UIKit
import CoreData

public protocol DTODescriptionCategoriesPoint {
    
    associatedtype MO: MODescriptionCategoriesPoint
    
    var color:  String?  {get set}
    var date:  Date?  {get set}
    var descr: String?  {get set}
    var icon: String?  {get set}
    var isDisabled: Bool  {get set}
    var name: String?  {get set}
    var predefined: Bool  {get set}
    var uuid: String  {get set}
    
    static func fromMO(_ mo: MO) -> Self?
    
    func createMO(context: NSManagedObjectContext) -> MO?
    
}

public protocol MODescriptionCategoriesPoint: NSManagedObject, NSFetchRequestResult {
    
    var uuid: String? { get }
     
    func apply(dto: any DTODescriptionCategoriesPoint)
    
    func toDTO() -> (any DTODescriptionCategoriesPoint)?
}
