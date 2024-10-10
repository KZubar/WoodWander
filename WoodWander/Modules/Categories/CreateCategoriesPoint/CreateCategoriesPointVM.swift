//
//  CreateCategoriesPointVM.swift
//  WoodWander
//
//  Created by k.zubar on 23.08.24.
//

import UIKit
import Storage

protocol CreateCategoriesPointCoordinatorProtocol: AnyObject {
    func finish()
}

protocol CategoriesPointDataWorkerUseCase {
    typealias CompletionHandler = (Bool) -> Void
    func createOrUpdate(dto: (any DTODescriptionCategoriesPoint), 
                        completion: CompletionHandler?)
}

final class CreateCategoriesPointVM: CreateCategoriesPointViewModelProtocol {
    
    private weak var coordinator: CreateCategoriesPointCoordinatorProtocol?

    var name: String?
    var descr: String?
    
    var color: String?
    var date: Date?
    var icon: String?
    var isDisabled: Bool = false
    var uuid: String?

    var catchNameError: ((String?) -> Void)?
    var catchDescrError: ((String?) -> Void)?

    private let dataWorker: CategoriesPointDataWorkerUseCase
    
    private var dto: (any DTODescriptionCategoriesPoint)?
    
    init(coordinator: CreateCategoriesPointCoordinatorProtocol,
         dto: (any DTODescriptionCategoriesPoint)?,
         dataWorker: CategoriesPointDataWorkerUseCase) {
        
        self.coordinator = coordinator
        self.dataWorker = dataWorker
        
        //в любом случае заполняем. Текущий или новый
        if let dtoCategories = dto as? CategoriesPointDTO {
            self.dto = dtoCategories
        } else {
            self.dto = CategoriesPointDTO()
        }
        
        if let dtoCategories = self.dto as? CategoriesPointDTO {
            self.name = dtoCategories.name
            self.descr = dtoCategories.descr
            self.color = dtoCategories.color
            self.date = dtoCategories.date
            self.icon = dtoCategories.icon
            self.isDisabled = dtoCategories.isDisabled
            self.uuid = dtoCategories.uuid
        }
        bind()
    }
    
    private func bind() { }
    
    func createDidTap() {
//        guard
//            checkValidation()
//        else { return }
        
        //проверим требуется ли установить новый uuid
        if let uuid = self.uuid {
            if uuid.isEmpty {
                self.uuid = UUID().uuidString
            }
        } else {
            self.uuid = UUID().uuidString
        }

        //проверим заполнение реквизитов
        guard
            let name,
            let descr,
            let uuid
        else { return }
        
        if name.isEmpty { return }
        
        //если это новый, то укажем
        if self.dto == nil {
            self.dto = CategoriesPointDTO(color: self.color,
                                          date: self.date,
                                          descr: descr,
                                          icon: self.icon,
                                          isDisabled: self.isDisabled,
                                          name: name,
                                          uuid: uuid)
        }
        
        //заполним для передачи в запись
        var dtoSave = self.dto as? CategoriesPointDTO
        dtoSave?.date = Date()
        dtoSave?.name = name
        dtoSave?.descr = descr
        dtoSave?.uuid = uuid
        
        dtoSave?.color = self.color
        dtoSave?.icon = self.icon
        dtoSave?.isDisabled = self.isDisabled
        
        //переопределим переменную с новыми данными
        self.dto = dtoSave
        
        //крайняя проверка на адекватность
        guard let dtoCategoriesPoin = self.dto as? CategoriesPointDTO else { return }

        self.dataWorker.createOrUpdate(dto: dtoCategoriesPoin) { _ in }
        
        self.coordinator?.finish()

    }
    
    func dismissDidTap() {
        coordinator?.finish()
    }
    
}


//extension CreateCategoriesPointVM {
//    //@discardableResult
//
//    private func checkValidation() -> Bool {
//
////        let isTitleValid = isValid(title)
////        let isDateValid = isValid(date)
////
////        catchTitleError?(isTitleValid ? nil : L10n.error_title)
////        catchDateError?(isDateValid ? nil : L10n.error_date)
////
////        return isTitleValid && isDateValid
//        return true
//    }
//
//    private func isValid(_ title: String?) -> Bool {
//        if let title {
//            return (!title.isEmpty) && (title != "")
//        } else { return false }
//    }
//    
//    private func isValid(_ targetDate: Date?) -> Bool {
//        return (targetDate != nil)
//    }
//}
