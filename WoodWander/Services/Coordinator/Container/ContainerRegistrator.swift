//
//  ContainerRegistrator.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import Foundation
import Storage
import StorageBLR

final class ContainerRegistrator {
    
    static func makeContainer() -> Container {
        let container = Container()
        
        container.register({ LocationHelper() })

        container.register({ AlertService(container: container) })
        container.register({ MKMapViewService() })

        //storage
        container.register({ PlanPointStorage<PlanPointDTO>() })
        container.register({ PPCategoriesStorage<PPCategoriesDTO>() })
        container.register({ CategoriesPointStorage<CategoriesPointDTO>() })

        container.register({ AllBlrStorage() })
        container.register({ AllBlrStorageCoordinate() })
        
        container.register({ BlrDataSourseService() })
        
        //worker storage
        container.register({
            let storage: CategoriesPointStorage<CategoriesPointDTO> = container.resolve()
            let storagePPCategories: PPCategoriesStorage<PPCategoriesDTO> = container.resolve()
            let storagePlanPoint: PlanPointStorage<PlanPointDTO> = container.resolve()
            let workerService: CategoriesPointDataWorker = CategoriesPointDataWorker(
                storage: storage,
                storagePPCategories: storagePPCategories,
                storagePlanPoint: storagePlanPoint
            )
            return workerService
        })
        container.register({
            let storage: PlanPointStorage<PlanPointDTO> = container.resolve()
            let storagePPCategories: PPCategoriesStorage<PPCategoriesDTO> = container.resolve()
            let workerService: PlanPointDataWorker = PlanPointDataWorker(
                storage: storage,
                storagePPCategories: storagePPCategories
           )
            return workerService
        })
        container.register({
            let storage: PPCategoriesStorage<PPCategoriesDTO> = container.resolve()
            let storagePlanPoint: PlanPointStorage<PlanPointDTO> = container.resolve()
            let workerService: PPCategoriesDataWorker = PPCategoriesDataWorker(
                storage: storage,
                storagePlanPoint: storagePlanPoint
            )
            return workerService
        })

        
        

        
        
        
        //FIXME: - почему возвращает одинаковый тип тут и ниже "return blrDataWorkerService"
        container.register({
            let storageBlr: AllBlrStorage = container.resolve()
            let storageBlrCoordinate: AllBlrStorageCoordinate = container.resolve()
            let blrDataSourseService: BlrDataSourseService = container.resolve()
            let blrDataWorkerService: BlrDataWorker = BlrDataWorker(
                storageBlr: storageBlr,
                storageBlrCoordinate: storageBlrCoordinate,
                blrDataSourseService: blrDataSourseService
            )
            return blrDataWorkerService
        })

        //FIXME: - почему возвращает одинаковый тип тут и выше "return blrDataWorkerService"
        container.register({
            let storage: PlanPointStorage<PlanPointDTO> = container.resolve()
            let storagePPCategories: PPCategoriesStorage<PPCategoriesDTO> = container.resolve()
            let blrDataWorkerService: PlanPointDataWorker = PlanPointDataWorker(
                storage: storage,
                storagePPCategories: storagePPCategories
            )
            return blrDataWorkerService
        })

        
        return container
    }
    
}


