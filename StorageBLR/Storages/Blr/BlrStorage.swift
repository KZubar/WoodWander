//
//  BlrStorage.swift
//  Storage
//
//  Created by k.zubar on 3.07.24.
//

import Foundation
import CoreData

public class BlrStorage<DTO: DTODescriptionBLR> {
    
    public typealias CompletionHandler = (Bool) -> Void
    public init() { }
    
    //fetchMO
    public func fetchMO(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = [],
        context: NSManagedObjectContext
    ) -> [DTO.MO] {
        let request = NSFetchRequest<DTO.MO>(entityName: "\(DTO.MO.self)")
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        let result = try? context.fetch(request)
        return result ?? []
    }
    
    //fetch
    public func fetch(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = []
    ) -> [any DTODescriptionBLR] {
        
        let context: NSManagedObjectContext = CoreDataService.shared.backgroundContext
        return fetchMO(
            predicate: predicate,
            sortDescriptors: sortDescriptors,
            context: context
        )
        .compactMap { $0.toDTO() }
    }
    
    //fetch - delete or not?
    public func fetchMOAllCoordinates() -> [BlrCoordinateMO] {
        let context: NSManagedObjectContext = CoreDataService.shared.backgroundContext
        let request = NSFetchRequest<BlrCoordinateMO>(entityName: "BlrCoordinateMO")
        let result = try? context.fetch(request)
        return result ?? []
    }

}
