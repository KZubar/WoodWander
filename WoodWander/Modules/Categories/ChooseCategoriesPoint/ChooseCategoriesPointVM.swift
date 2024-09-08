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

    private let dataWorker: PPCategoriesDataWorkerUseCase
    private weak var delegateVM: MapPlanPointsViewModelDelegat?
    
    var point: PlanPointDescription
    var modified: Bool = false

    var showPopover: ((_ sender: UIView) -> Void)?
    
    init(frcService: ChooseCategoriesPointFRCServiceCategoriesPointUseCase,
         point: PlanPointDescription,
         delegateVM: MapPlanPointsViewModelDelegat?,
         adapter: ChooseCategoriesPointAdapterProtocol,
         coordinator: ChooseCategoriesPointCoordinatorProtocol,
         dataWorker: PPCategoriesDataWorkerUseCase
    ) {
        self.frcService = frcService
        self.adapter = adapter
        self.coordinator = coordinator
        self.point = point
        self.delegateVM = delegateVM
        self.dataWorker = dataWorker

        bind()
    }
    
    private func bind() {
        frcService.didChangeContent = { [weak self] _ in
            
            guard let self else { return }

            //список всех категорий в БД
            let dtosCategories: [any DTODescriptionCategoriesPoint]  = self.frcService.fetcherDTOs

            //Разделим категории на предопределенные и пользовательские
            let dtosPredefined = self.getDtosPredefined(dtosCategories)
            let dtosCustom = self.getDtosCustom(dtosCategories)
            
            //есть вероятность, что была добавлена новая категория.
            //найдем новые ключи и добавим их в массивы
            //для этого:
            //1.    Cоздаем словарь для быстрого доступа к значениям по uuid
            //      (важно наличие записи, а значение isUsed не важно)
            let dictBaseDtos = Dictionary(uniqueKeysWithValues: self.baseDtos.map { ($0.uuidCategory,   $0.isUsed) })
            //2.    Bщем недостающее значение и добавляем в оба массива с значением isUsed = false
            for i in 0..<dtosCategories.count {
                let uuid = dtosCategories[i].uuid
                if dictBaseDtos[uuid] == nil {
                    let newDto = PPCategoriesDTO(uuidPoint: self.point.uuid,
                                                      uuidCategory: uuid,
                                                      descr: "",
                                                      isUsed: false)
                    self.saveDtos.append(newDto) //не забываем про копию
                    self.baseDtos.append(newDto) //не забываем про копию
                }
            }

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
        let dtosCategories: [any DTODescriptionCategoriesPoint] = self.frcService.fetcherDTOs


        //список категорий принадлежащих точке
        var dtos: [any DTODescriptionPPCategories] = []
        if !point.uuid.isEmpty {
            dtos = dataWorker.fetch(
                predicate: .PPCategories.categories(byUuidPoin: point.uuid),
                sortDescriptors: [.PPCategories.byUuidCategory]
            )
        }

        
        //создадим пустой массив PPCategoriesDTO на основании справочника dtosCategories
        var emptyDto: [any DTODescriptionPPCategories] = dtosCategories.compactMap { categoryDto in
            if categoryDto.uuid == CategoriesPointPredefined.marked.uuid { return nil } //исключим категорию "marked"
            return PPCategoriesDTO(uuidPoint: point.uuid,
                                              uuidCategory: categoryDto.uuid,
                                              descr: "",
                                              isUsed: false)
        }
        
        //заполним пустой массив значениями из базы
        if dtos.count > 0 {
            updateIsUsed(from: dtos, to: &emptyDto)
        }
        //сохраним результат в первичный массив (до изменений пользователя)
        //и во второй массив (результат коррекций пользователя)
        self.saveDtos = emptyDto
        self.baseDtos = emptyDto

        //теперь имеем все данные из coreData и их нужно передать в adapter
        self.customReloadData(dtosCategories)
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
        //сразу определяемся новый элемент или нет
        let isNewElement = point.uuid.isEmpty
        
        //уточнимся по uuid точки (это может быть нлвая точка
        let id = isNewElement ? UUID().uuidString : point.uuid
        
        //это всегда новая дата (даже при коррекции)
        let date = isNewElement ? Date() : point.date

        //всегда добавляем в список CategoriesPointPredefined.marked
        if let index = saveDtos.firstIndex(
            where: { $0.uuidCategory == CategoriesPointPredefined.marked.uuid }
        ) {
            saveDtos[index].isUsed = true
        }

        var dtoPointSave: PlanPointDTO = PlanPointDTO(
            uuid: id,
            date: date,
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
            self.saveDtos[i].uuidPoint = id
        }

        self.dataWorker.create(dtoPoint: dtoPointSave,
                               dtosPPCategories: self.saveDtos) { [weak self, dtoPointSave] isSuccess in
            guard isSuccess else { return }
            
            self?.point.uuid = dtoPointSave.uuid
            self?.point.date = dtoPointSave.date

            self?.delegateVM?.addNewPoint(point: dtoPointSave)
        }
        
        
        self.coordinator?.finish()
        
    }
}


extension ChooseCategoriesPointVM {
    
    private func getDtosPredefined(_ dtos: [any DTODescriptionCategoriesPoint]) -> [any DTODescriptionCategoriesPoint] {
        var dtosPredefined = dtos
            .compactMap { if $0.predefined  == true { return $0 } else { return nil } }
        //удалим один
        dtosPredefined.removeAll { $0.uuid == CategoriesPointPredefined.marked.uuid }
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
        
        //заполним первый в списке элемент как true вне зависимости значения в базе
        //и укажем принудительно, что массив был модифицирован
        if let item = dtosCustom.first {
            if !item.uuid.isEmpty {
                dictCheck[item.uuid] = true
                if let index = saveDtos.firstIndex(where: { $0.uuidCategory == item.uuid }) {
                    saveDtos[index].isUsed = true
                }
                self.modified = true
            }
        }
        
        self.adapter.reloadData(dtosPredefined: dtosPredefined,
                                dtosCustom: dtosCustom,
                                dictCheck: dictCheck)
    }
    
    //роходим по элементам array2 и обновляем их значения value, если соответствующий uuid найден в dict1
    private func updateIsUsed(from array1: [any DTODescriptionPPCategories],
                              to array2: inout [any DTODescriptionPPCategories]) {
        // Создаем словарь для быстрого доступа к значениям по uuid
        let dict1 = Dictionary(uniqueKeysWithValues: array1.map { ($0.uuidCategory, $0.isUsed) })
        
        // Обновляем значения в array2 на основе значений из dict1
        for i in 0..<array2.count {
            if let newValue = dict1[array2[i].uuidCategory] {
                array2[i].isUsed = newValue
            }
        }
    }

}
