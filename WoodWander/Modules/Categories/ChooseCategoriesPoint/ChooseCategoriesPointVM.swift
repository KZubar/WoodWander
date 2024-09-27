//
//  ChooseCategoriesPointVM.swift
//  WoodWander
//
//  Created by k.zubar on 27.08.24.
//

import UIKit
import Storage

protocol ChooseCategoriesPointAdapterProtocol: AnyObject {
    //func reloadData(_ dtoList: [any DTODescriptionCategoriesPoint])
    func reloadData(dtosPredefined: [any DTODescriptionCategoriesPoint],
                    dtosCustom: [any DTODescriptionCategoriesPoint],
                    dictCheck: [String: Bool])
    func makeTableView() -> UITableView
    var tapButtonOnDTO: ((_ dto: (any DTODescriptionCategoriesPoint)?,
                          _ check: Bool,
                          _ indexPath: IndexPath) -> Void)? { get set }
    var descrTextViewDidChangeHandle: ((_ dto: (any DTODescriptionCategoriesPoint)?,
                                        _ descr: String?) -> Void)? { get set }
}

protocol ChooseCategoriesPointCoordinatorProtocol: AnyObject {
    func finish()
    func openEditCategoriesPoint(dto: (any DTODescriptionCategoriesPoint)?)
    func showQuestionFinishViewControler(completion: ((Bool) -> Void)?)
}

protocol ChooseCategoriesPointFRCServiceCategoriesPointUseCase {
    var fetcherDTOs: [any DTODescriptionCategoriesPoint] { get }
    var didChangeContent: (([any DTODescriptionCategoriesPoint]) -> Void)? { get set }
    func startHandle()
}

protocol PPCategoriesDataWorkerUseCase {
    typealias CompletionHandler = (Bool) -> Void
    func create(dtoPoint: (any DTODescriptionPlanPoint),
                dtosPPCategories: [any DTODescriptionPPCategories],
                completion: CompletionHandler?)
    func fetch(predicate: NSPredicate?,
               sortDescriptors: [NSSortDescriptor]) -> [any DTODescriptionPPCategories]
}

final class ChooseCategoriesPointVM: ChooseCategoriesPointViewModelProtocol {
        
    private let adapter: ChooseCategoriesPointAdapterProtocol
    private var frcService: ChooseCategoriesPointFRCServiceCategoriesPointUseCase
    private weak var coordinator: ChooseCategoriesPointCoordinatorProtocol?
    
    private var selectedDTO: (any DTODescriptionCategoriesPoint)?
    private var selectedIndexPath: IndexPath?
    private var baseDtos: [any DTODescriptionPPCategories] = []
    private var saveDtos: [any DTODescriptionPPCategories] = []
    private var categoriesDtos: [any DTODescriptionCategoriesPoint] = []
    
    private let dataWorker: PPCategoriesDataWorkerUseCase
    
    var point: PlanPointDescription
    var modified: Bool = false

    var showPopover: ((_ sender: UIView) -> Void)?
    
    init(frcService: ChooseCategoriesPointFRCServiceCategoriesPointUseCase,
         point: PlanPointDescription,
         adapter: ChooseCategoriesPointAdapterProtocol,
         coordinator: ChooseCategoriesPointCoordinatorProtocol,
         dataWorker: PPCategoriesDataWorkerUseCase
    ) {
        self.frcService = frcService
        self.adapter = adapter
        self.coordinator = coordinator
        self.point = point
        self.dataWorker = dataWorker

        bind()
    }
        
    private func bind() {
        frcService.didChangeContent = { [weak self] _ in
            
            guard let self else { return }
            
            //список всех категорий в справочнике в БД
            let fetcherDtos = self.frcService.fetcherDTOs
            
            //найдем то, что добавили
            var newCategoryDto: (any DTODescriptionCategoriesPoint)?
            let dictDtos = Dictionary(uniqueKeysWithValues: self.categoriesDtos.map { ($0.uuid, $0) })
            for i in 0..<fetcherDtos.count {
                if dictDtos[fetcherDtos[i].uuid] == nil {
                    newCategoryDto = fetcherDtos[i]
                }
            }

            //нет смысла продолжать, если ничего не изменилось
            guard let newCategoryDto else { return }

            let newPPCategoriesDTO = PPCategoriesDTO(uuidPoint: self.point.uuid,
                                                     uuidCategory: newCategoryDto.uuid,
                                                     descr: "",
                                                     isUsed: false)
            //добавляем в массивчики
                self.categoriesDtos.insert(newCategoryDto, at: 0)
                self.saveDtos.append(newPPCategoriesDTO)
                self.baseDtos.append(newPPCategoriesDTO)
            
            
            //Разделим категории на предопределенные и пользовательские
            let dtosPredefined = self.getDtosPredefined(self.categoriesDtos)
            let dtosCustom = self.getDtosCustom(self.categoriesDtos)
            
            
            // Создаем словарь
            let dictCheck = Dictionary(uniqueKeysWithValues: self.saveDtos.map { ($0.uuidCategory, $0.isUsed) })
            
            self.adapter.reloadData(dtosPredefined: dtosPredefined,
                                    dtosCustom: dtosCustom,
                                    dictCheck: dictCheck)
        }
        adapter.tapButtonOnDTO = { [weak self] dto, check, indexPath in
            guard let self else { return }
            self.modified = true
            self.selectedDTO = dto
            self.selectedIndexPath = indexPath
            if let dto = dto {
                if let index = self.saveDtos.firstIndex(where: { $0.uuidCategory == dto.uuid }) {
                    self.saveDtos[index].isUsed = check
                }
            }
            
            //self.coordinator?.showMenu(dto: dto, completion: didChangeMenuAction)
        }
        adapter.descrTextViewDidChangeHandle = { [weak self] dto, descr in
            if let uuid = dto?.uuid, let index = self?.saveDtos.firstIndex(
                where: { $0.uuidCategory == uuid }
            ) {
                self?.saveDtos[index].descr = descr
            }
            
        }
        
    }
    
    func viewDidLoad() {

        //список всех категорий в БД
        frcService.startHandle()
        self.categoriesDtos = self.frcService.fetcherDTOs

        //список категорий принадлежащих точке
        let dtos = dataWorker.fetch(
            predicate: .PPCategories.categories(byUuidPoin: point.uuid),
            sortDescriptors: [.PPCategories.byUuidCategory]
        )

        
        //создадим пустой массив PPCategoriesDTO на основании справочника dtosCategories
        var emptyDto: [any DTODescriptionPPCategories] = self.categoriesDtos.compactMap { categoryDto in
            return PPCategoriesDTO(uuidPoint: point.uuid,
                                              uuidCategory: categoryDto.uuid,
                                              descr: "",
                                              isUsed: false)
        }
        
        //заполним реквизит "isUsed" значениями из базы
        if dtos.count > 0 {
            updateDtoFromData(from: dtos, to: &emptyDto)
        }
        
        //сохраним результат в первичный массив (до изменений пользователя)
        //и во второй массив (результат коррекций пользователя)
        self.saveDtos = emptyDto
        self.baseDtos = emptyDto
        
        //заполним реквизит "descr" значениями из базы
        if emptyDto.count > 0 {
            // Создаем словарь для быстрого доступа к значениям по uuid
            let dict = Dictionary(uniqueKeysWithValues: emptyDto.map { ($0.uuidCategory, $0.descr) })

            // Обновляем значения в array на основе значений из dict
            for i in 0..<self.categoriesDtos.count {
                if let newValue = dict[self.categoriesDtos[i].uuid] {
                    self.categoriesDtos[i].descr = newValue
                }
            }
        }

        //теперь имеем все данные из coreData и их нужно передать в adapter
        self.customReloadData(self.categoriesDtos)
    }
    
    func makeTableView() -> UITableView {
        return adapter.makeTableView()
    }

    func dismissDidTap() {
        if self.modified {
            self.coordinator?.showQuestionFinishViewControler { [weak self] isSuccess in
                if isSuccess {
                    self?.coordinator?.finish()
                }
            }
        } else {
            coordinator?.finish()
        }
    }

    
    func openEditCategoriesPoint() {
        self.coordinator?.openEditCategoriesPoint(dto: nil)
    }
    
    func saveDidTap() {
        
        var dtoPointSave: PlanPointDTO = PlanPointDTO(
            uuid: point.uuid,
            date: point.date,
            latitude: point.latitude,
            longitude: point.longitude,
            name: point.name ?? "",
            descr: point.descr ?? "",
            isDisabled: point.isDisabled,
            oblast: point.oblast ?? "",
            region: point.region ?? "",
            regionInMeters: point.regionInMeters,
            radiusInMeters: point.radiusInMeters,
            color: point.color ?? "",
            icon: point.icon ?? "",
            imagePathStr: point.imagePathStr ?? ""
        )
        
        //заполнить ее uuid
        for i in 0..<self.saveDtos.count {
            self.saveDtos[i].uuidPoint = point.uuid
        }
        
        //получим параметры иконки и цвета по первой категории в списке
        var iconByPoint: String? //= dtoPointSave.icon
        var colorByPoint: String? //= dtoPointSave.icon
        for i in 0..<self.saveDtos.count {
            if self.saveDtos[i].isUsed {
                let uuidCategoryByIcon = self.saveDtos[i].uuidCategory
                
                if let index = self.categoriesDtos.firstIndex(
                    where: { $0.uuid == uuidCategoryByIcon }
                ) {
                    iconByPoint = categoriesDtos[index].icon
                    colorByPoint = categoriesDtos[index].color
                }
                break
            }
        }
        dtoPointSave.icon = iconByPoint
        dtoPointSave.color = colorByPoint

        //запишем
        self.dataWorker.create(
            dtoPoint: dtoPointSave,
            dtosPPCategories: self.saveDtos
        ) { [weak self] isSuccess in
            guard isSuccess else { return }
            
            self?.point.uuid = dtoPointSave.uuid
            self?.point.date = dtoPointSave.date
           
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .updatePoint,
                    object: nil
                )
            }
        }
        
        //закроем
        self.coordinator?.finish()
        
    }
}


extension ChooseCategoriesPointVM {
    
    private func getDtosPredefined(_ dtos: [any DTODescriptionCategoriesPoint]) -> [any DTODescriptionCategoriesPoint] {
        var dtosPredefined = dtos.compactMap {
            if $0.predefined  == true { return $0 } else { return nil }
        }
        return dtosPredefined
    }
    
    private func getDtosCustom(_ dtos: [any DTODescriptionCategoriesPoint]) -> [any DTODescriptionCategoriesPoint] {
        let dtosCustom = dtos
            .compactMap { if $0.predefined == false { return $0 } else { return nil } }
        return dtosCustom
    }
    
    private func customReloadData(_ dtos: [any DTODescriptionCategoriesPoint]) {

        //adapter использует два dto типа DTODescriptionCategoriesPoint
        //и словарь формата (String: Bool) (uuid: isUsed)
        
        let dtosPredefined = getDtosPredefined(dtos)
        let dtosCustom = getDtosCustom(dtos)
        
        // Создаем словарь для быстрого доступа к значениям по uuid
        var dictCheck = Dictionary(uniqueKeysWithValues: dtos.map { ($0.uuid, false) })
        // Обновляем значения в dictCheck на основе значений из saveDtos
        for i in 0..<saveDtos.count {
            dictCheck[saveDtos[i].uuidCategory] = saveDtos[i].isUsed
        }
                
        self.adapter.reloadData(dtosPredefined: dtosPredefined,
                                dtosCustom: dtosCustom,
                                dictCheck: dictCheck)
    }
        
    //проходим по элементам array2 и обновляем их значения value, если соответствующий uuid найден в dict
    private func updateDtoFromData(from array1: [any DTODescriptionPPCategories],
                                   to array2: inout [any DTODescriptionPPCategories]) {
        // Создаем словарь для быстрого доступа к значениям по uuid
        let dict = Dictionary(uniqueKeysWithValues: array1.map { ($0.uuidCategory, $0) })

        // Обновляем значения в array на основе значений из dict
        for i in 0..<array2.count {
            if let newValue = dict[array2[i].uuidCategory] {
                array2[i].isUsed = newValue.isUsed
                array2[i].descr = newValue.descr
            }
        }
    }

}
