//
//  FRCServiceCategoriesPoint.swift
//  Storage
//
//  Created by k.zubar on 21.08.24.
//

import CoreData

public final class FRCServiceCategoriesPoint<DTO: DTODescriptionCategoriesPoint>: NSObject,
                                                         NSFetchedResultsControllerDelegate {
    
    public var didChangeContent: (([any DTODescriptionCategoriesPoint])->Void)?
    
    private let request: NSFetchRequest<DTO.MO> = {
        return NSFetchRequest<DTO.MO>(entityName: "\(DTO.MO.self)")
    }()
    
    private lazy var frc: NSFetchedResultsController<DTO.MO> = {
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: CoreDataService.shared.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    public var fetcherDTOs: [any DTODescriptionCategoriesPoint] {
        let dtos = frc.fetchedObjects?.compactMap{ $0.toDTO() }
        return dtos ?? []
    }
    
    public init(_ requestBuilder: (NSFetchRequest<DTO.MO>) -> Void) {
        requestBuilder(self.request)
    }
    
    public func startHandle() {
        try? frc.performFetch()
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        try? controller.performFetch()
        didChangeContent?(fetcherDTOs)
    }
}
