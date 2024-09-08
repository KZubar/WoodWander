//
//  CoreDataService.swift
//  Storage
//
//  Created by k.zubar on 26.06.24.
//

import CoreData

final class CoreDataService {
    
    typealias CompletionHandler = ((Bool) -> Void)
    
    static let shared: CoreDataService = .init()
    
    private init() {}
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
        
    var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
        
    //постоянный контейнер
    private var persistentContainer: NSPersistentContainer = {
        let modelName = "PointDataBase"
        let bundle = Bundle(for: CoreDataService.self)
        
        guard
            let modelURL = bundle.url(
                forResource: modelName,
                withExtension: "momd"
            ),
            let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        else { fatalError("unable to find model in bundle") }
        
        let container = NSPersistentContainer(
            name: modelName,
            managedObjectModel: managedObjectModel
        )
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //записать mainContext
    func saveMainContext (completion: CompletionHandler? = nil) {
        saveContext(context: mainContext, completion: completion )
    }
    
    //записать context
    func saveContext (context: NSManagedObjectContext,
                      completion: CompletionHandler? = nil) {
        if context.hasChanges {
            do {
                try context.save()
                completion?(true)
            } catch {
                let nserror = error as NSError
                completion?(false)
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
