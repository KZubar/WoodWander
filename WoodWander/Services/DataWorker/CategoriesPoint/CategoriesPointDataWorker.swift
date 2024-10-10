//
//  CategoriesPointDataWorker.swift
//  WoodWander
//
//  Created by k.zubar on 25.08.24.
//

import UIKit
import Storage

final class CategoriesPointDataWorker {

    typealias CompletionHandler = (Bool) -> Void
    
    private let storage: CategoriesPointStorage<CategoriesPointDTO>
    private let storagePPCategories: PPCategoriesStorage<PPCategoriesDTO>
    private let storagePlanPoint: PlanPointStorage<PlanPointDTO>

    init(
        storage: CategoriesPointStorage<CategoriesPointDTO>,
        storagePPCategories: PPCategoriesStorage<PPCategoriesDTO>,
        storagePlanPoint: PlanPointStorage<PlanPointDTO>
    ) {
        self.storage = storage
        self.storagePPCategories = storagePPCategories
        self.storagePlanPoint = storagePlanPoint
    }
    
    //MARK: createOrUpdate
    func createOrUpdate(dto: (any DTODescriptionCategoriesPoint), 
                        completion: CompletionHandler? = nil) {
        //1. запишем
        storage.createOrUpdate(dto: dto) { [weak self] isSuccess in
            
            guard isSuccess else { completion?(false); return }

            //2. получить список точек, использующих эту категорию
            if isSuccess {
                var dtosPPCategories: [(any DTODescriptionPPCategories)]
                dtosPPCategories = self?.getPPCategories(categoryUuid: dto.uuid, isUsed: true) ?? []
                if dtosPPCategories.count > 0 {
                    //3. получаем массив uuid точек для которых требуется переопределить параметры
                    let uuidsPoint = dtosPPCategories.compactMap { $0.uuidPoint }
                    if uuidsPoint.count > 0 {
                        //4. Заменим у точек цвет и иконку
                        self?.updateParamForPoints(uuidsPoint: uuidsPoint)
                    }
                }
            }
            completion?(isSuccess)
        }
   }
    
    //MARK: deleteByUser
    func deleteByUser(dto: (any DTODescriptionCategoriesPoint), 
                      completion: CompletionHandler? = nil) {

        //1. получить список точек, использующих эту категорию
        var dtosPPCategories: [(any DTODescriptionPPCategories)]
        dtosPPCategories = getPPCategories(categoryUuid: dto.uuid, isUsed: true)
        
        //2. получаем массив uuid точек для которых требуется переопределить параметры
        let uuidsPoint = dtosPPCategories.compactMap { $0.uuidPoint }

        //3. удаляем категорию
        storage.delete(dto: dto) { [weak self] isSuccess in
            
            guard isSuccess else { completion?(false); return }
            
            if isSuccess {
                //4. удаляем связи точки с категорией
                self?.storagePPCategories.deleteForCategory(dto: dto) { [weak self] isSuccess in
                    
                    guard isSuccess else { completion?(false); return }
                    
                    //5. Заменим у точек цвет и иконку
                    if isSuccess && uuidsPoint.count > 0 {
                        self?.updateParamForPoints(uuidsPoint: uuidsPoint) { isSuccess in
                            defer { completion?(isSuccess) }
                            guard isSuccess else { return }
                       }
                    } else {
                        completion?(false)
                    }
                }
            } else {
                completion?(false)
            }
        }
    }
    

}


extension CategoriesPointDataWorker {
    
    //получить связи точек и категорий
    private func getPPCategories(
        categoryUuid: String,
        isUsed: Bool? = nil
    ) -> [any DTODescriptionPPCategories] {
        let predicate: NSPredicate = .PPCategories.points(
            byUuidCategory: categoryUuid,
            isUsed: isUsed
        )
        let sortDescriptors: [NSSortDescriptor] = []
        return storagePPCategories.fetch(predicate: predicate,
                                         sortDescriptors: sortDescriptors)
    }
    
    //обновить параметры цвета и картинки в точках на основнии переданного списка dtosPPCategories
    private func updateParamForPoints(
        uuidsPoint: [String],
        completion: CompletionHandler? = nil
    ) {
    
        //получим список связей точек из массива и их категорий
        let dtosPPCategories = self.storagePPCategories.fetch(
            predicate: .PPCategories.byPoints(in: uuidsPoint, isUsed: true),
            sortDescriptors: [.PPCategories.byUuidPoint,
                              .PPCategories.byUuidCategory]
        )
                
        //получим справочник категорий
        let dtosCategory = storage.fetchDTO(
            predicate: .Point.all,
            sortDescriptors: [.CategoriesPoint.byIsDisabled,
                              .CategoriesPoint.byDate,
                              .CategoriesPoint.byName]
        )
 
        //получим список dto точек для изменения в них картинки и цвета
        var pointDtos = storagePlanPoint.fetchDTO(predicate: .Point.points(in: uuidsPoint))
        //и обнулимся
        for i in 0..<pointDtos.count {
            pointDtos[i].color = nil
            pointDtos[i].icon = nil
        }

        //нет понимания какую иконку назначать точке, поэтому назначим первую найденную в массиве
        //то есть сортировка массива является эталоном для назначения параметров точкам

        // Создаем словарь для быстрого доступа к категориям по uuid
        var categoryDict: [String: Int] = [:]
        for (index, category) in dtosCategory.enumerated() {
            categoryDict[category.uuid] = index
        }

        // Обновляем точки
        for i in 0..<pointDtos.count {
            
            let relevantCategories = dtosPPCategories.filter { $0.uuidPoint == pointDtos[i].uuid }
            let minIndexCategory = relevantCategories.min { item1, item2 in
                guard let index1 = categoryDict[item1.uuidCategory] else { return false }
                guard let index2 = categoryDict[item2.uuidCategory] else { return false }

                return index1 < index2
            }
            
            if let minIndexCategory = minIndexCategory,
               let categoryIndex = categoryDict[minIndexCategory.uuidCategory] {
                pointDtos[i].color = dtosCategory[categoryIndex].color
                pointDtos[i].icon = dtosCategory[categoryIndex].icon
            }
        }
               
        storagePlanPoint.updateDTOs(dtos: pointDtos, completion: completion)
    }

}
