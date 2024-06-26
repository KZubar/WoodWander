//
//  PlanPointStorage.swift
//  Storage
//
//  Created by k.zubar on 26.06.24.
//

import CoreData

public final class PlanNotificationStorage: PointStorage<PlanPointDTO> {
    
    public func fetch(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = []
    ) -> [PlanPointDTO] {
        
        return super.fetch(
            predicate: predicate,
            sortDescriptors: sortDescriptors
        ).compactMap { $0 as? PlanPointDTO}
    }

}

