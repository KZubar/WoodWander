//
//  MapPlanPointsAssembler.swift
//  WoodWander
//
//  Created by k.zubar on 27.06.24.
//

import UIKit
import Storage
import StorageBLR

final class MapPlanPointsAssembler {
    
    private init() {}
    
    static func make(
        container: Container,
        coordinator: MapPlanPointsCoordinatorProtocol
    ) -> UIViewController {
        
        let alertService: AlertService = container.resolve()
        let mapService: MKMapViewService = container.resolve()
        let frcServicePP = makeFRC()
        let blrDataWorker: BlrDataWorker = container.resolve()
        

        let vm = MapPlanPointsVM(coordinator: coordinator,
                                 frcServicePP: frcServicePP,
                                 blrDataWorker: blrDataWorker,
                                 mapService: mapService,
                                 alertService: alertService)
        let vc = MapPlanPointsVC(viewModel: vm)
        return vc
    }

    private static func makeFRC() -> Storage.FRCServicePlanPoint<PlanPointDTO> {
        return .init { request in
            request.predicate = .Point.all
            request.sortDescriptors = [.Point.byDate]
        }
    }
}
