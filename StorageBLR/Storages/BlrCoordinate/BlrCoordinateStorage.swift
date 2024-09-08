//
//  BlrCoordinateStorage.swift
//  StorageBLR
//
//  Created by k.zubar on 6.07.24.
//

import Foundation

import Foundation
import CoreData

public class BlrCoordinateStorage<DTO: DTODescriptionCoordinateBLR> {
    
    public typealias CompletionHandler = (Bool) -> Void
    public init() { }
    
    //fetchMO
    func fetchMO(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = []
    ) -> [DTO.MO] {
        let context: NSManagedObjectContext = CoreDataService.shared.backgroundContext
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
    ) -> [any DTODescriptionCoordinateBLR] {
        
        return fetchMO(
            predicate: predicate,
            sortDescriptors: sortDescriptors
        ).compactMap { $0.toDTO() }
    }
    

}
