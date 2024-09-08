//
//  BlrDataWorker.swift
//  WoodWander
//
//  Created by k.zubar on 4.07.24.
//

import StorageBLR

//protocol NotificationServiceDataWorkerUseCase {
//    func makeNotificaions(from dtos: [any DTODescription])
//    func removeNotifications(id: [String])
//}


final class BlrDataWorker {
    
    typealias CompletionHandler = (Bool) -> Void

    private let storageBlr: AllBlrStorage
    private let storageBlrCoordinate: AllBlrStorageCoordinate
    private let blrDataSourseService: BlrDataSourseService

    init(
        storageBlr: AllBlrStorage,
        storageBlrCoordinate: AllBlrStorageCoordinate,
        blrDataSourseService: BlrDataSourseService
    ) {
        self.storageBlr = storageBlr
        self.storageBlrCoordinate = storageBlrCoordinate
        self.blrDataSourseService = blrDataSourseService
    }

    
    ///
    ///
    ///        let dataSourse = EventDataSourse()
    ///        mapView.addOverlays(dataSourse.overlays)
    ///        mapView.addAnnotations(dataSourse.annotation)
    ///
    ///
    ///
    ///нужно все удалить в BlrCoordinateMO
    ///нужно все удалить в BlrMO
    ///нужно загрузить в BlrMO
    ///нужно загрузить в BlrCoordinateMO
    ///
    ///
    
    func fetch(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = []
    ) -> [any DTODescriptionBLR] {
        return storageBlr.fetch(predicate: predicate,
                                sortDescriptors: sortDescriptors)
    }
    
    private func deleteInCoreData(completion: CompletionHandler?) {
        self.storageBlr.deleteAll(completion: completion)
    }

    func startLoad() {
        self.printInfo("1. Начало удаления данных")
        self.deleteInCoreData() { [weak self] isSuccessDelete in
            self?.printInfo(isSuccessDelete ? "-- Удаление = ОК" : "-- Удаление = ERROR")
            if isSuccessDelete {
                self?.printInfo("2. Начало загрузки данных ")
                self?.loadFilesToCoreData()
            }
        }
    }
    
    private func loadFilesToCoreData() {
        
        let backgroundQueue = DispatchQueue.global(qos: .background)
        
        
        backgroundQueue.async { [weak self] in
            backgroundQueue.sync { [weak self] in
                if let dtos = self?.blrDataSourseService.getDtos(name: "BLR0") {
                    self?.storageBlr.createDTOs(dtos: dtos) { isSuccess in
//                        if isSuccess {
//                            self?.storageBlrCoordinate.createDTOs(
//                        }
                        self?.printInfo("1. Конец загрузки данных ")
                    }
                }
            }
            backgroundQueue.sync {
                if let dtos = self?.blrDataSourseService.getDtos(name: "BLR1") {
                    self?.storageBlr.createDTOs(dtos: dtos) { isSuccess in
                        self?.printInfo("2. Конец загрузки данных ")
                    }
                }
            }
            backgroundQueue.sync {
                if let dtos = self?.blrDataSourseService.getDtos(name: "BLR2") {
                    self?.storageBlr.createDTOs(dtos: dtos) { isSuccess in
                        self?.printInfo("3. Конец загрузки данных ")
                    }
                }
            }
            
        }

    }
    

    //FIXME: - 
    private func printInfo(_ info: String) {
        
        let blrCoordinateMOs = storageBlr.fetchMOAllCoordinates()

        let dtos = self.fetch()
        
        print(" ")
        print("============================================================")
        print(" \(info) ")
        print("============================================================")
        print(" ")

        
        print("Количество записей в таблице BlrMO: \(dtos.count) записей")
        print("Количество записей в таблице BlrCoordinateMO: \(blrCoordinateMOs.count) записей")
        print(" ")
        //print("------------------------------------------------------------")

    

//        var i: Int = 0
//        dtos.forEach { dto in
//            i += 1
//            print(" ")
//            print("\(i). Количество Coordinate: \(dto.coordinates?.count ?? 0) записей")
//            print("latitude: \(dto.latitude)")
//            print("longitude: \(dto.longitude)")
//
//            print("gid_0: \(dto.gid_0 ?? "nil")")
//            print("gid_1: \(dto.gid_1 ?? "nil")")
//            print("gid_2: \(dto.gid_2 ?? "nil")")
//            
//            print("name_0: \(dto.name_0 ?? "nil")")
//            print("name_1: \(dto.name_1 ?? "nil")")
//            print("name_2: \(dto.name_2 ?? "nil")")
//           
//            print("type_0: \(dto.type_0 ?? "nil")")
//            print("type_1: \(dto.type_1 ?? "nil")")
//            print("type_2: \(dto.type_2 ?? "nil")")
//            
//            print("country:     \(dto.country ?? "nil")")
//            print("engType_1:   \(dto.engType_1 ?? "nil")")
//            print("engType_2:   \(dto.engType_2 ?? "nil")")
//            print("hasc_1:      \(dto.hasc_1 ?? "nil")")
//            print("hasc_2:      \(dto.hasc_2 ?? "nil")")
//            print("nl_name_1:   \(dto.nl_name_1 ?? "nil")")
//            print("nl_name_2:   \(dto.nl_name_2 ?? "nil")")
//            print("varname_1:   \(dto.varname_1 ?? "nil")")
//            print("varname_2:   \(dto.varname_2 ?? "nil")")
//        }
    }
    
    
    
//    //MARK: createOrUpdate
//    func create(
//        dto: (any DTODescriptionBLR),
//        completion: CompletionHandler? = nil
//    ) {
//        storage.createOrUpdate(dto: dto) { [notificationService, backupService] isSuccess in
//            defer { completion?(isSuccess) }
//            
//            guard isSuccess else { return }
//            
//            //используем сильные ссылки для захвата
//            notificationService.makeNotificaions(from: [dto])
//            backupService.backup(dto: dto)
//        }
//    }
    
//    //MARK: deleteByUser
//    func deleteByUser(dto: (any DTODescription), completion: CompletionHandler? = nil) {
//        storage.delete(dto: dto) { [notificationService, backupService] isSuccess in
//            defer { completion?(isSuccess) }
//            
//            guard isSuccess else { return }
//            
//            //используем сильные ссылки для захвата
//            notificationService.removeNotifications(id: [dto.id])
//            backupService.delete(id: dto.id)
//        }
//    }
//    
//    //MARK: deleteAllByLogout
//    func deleteAllByLogout(completion: CompletionHandler? = nil) {
//        let allDTO = storage.fetch()
//        let allId = allDTO.map { $0.id }
//        
//        notificationService.removeNotifications(id: allId)
//        storage.deleteAll(dtos: allDTO, completion: completion)
//    }
//    
//    //MARK: restore
//    func restore(completion: CompletionHandler? = nil) {
//        backupService.loadBackup { [weak self] dtos in
//            self?.storage.createDTOs(dtos: dtos) { isSuccess in
//                defer { completion? (isSuccess) }
//                
//                guard isSuccess else { return }
//                
//                self?.notificationService.makeNotificaions(from: dtos)
//            }
//        }
//    }

    
}
