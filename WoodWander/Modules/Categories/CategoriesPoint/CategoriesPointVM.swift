//
//  File.swift
//  WoodWander
//
//  Created by k.zubar on 28.08.24.
//

//
//  CategoriesPointVM.swift
//  WoodWander
//
//  Created by k.zubar on 21.08.24.
//

import UIKit
import Storage


protocol CategoriesPointAdapterProtocol: AnyObject {
    func reloadData(_ dtoList: [any DTODescriptionCategoriesPoint])
    func makeTableView() -> UITableView
    var tapButtonOnDTO: ((_ dto: (any DTODescriptionCategoriesPoint)?,
                          _ indexPath: IndexPath) -> Void)? { get set }
}

protocol CategoriesPointCoordinatorProtocol: AnyObject {
    typealias CompletionHandler = (_ action: CategoriesPointMenuAction) -> Void
    func finish()
    func openEditCategoriesPoint(dto: (any DTODescriptionCategoriesPoint)?)
    func showMenu(dto: (any DTODescriptionCategoriesPoint)?, completion: CompletionHandler?)
}

protocol CategoriesPointFRCServiceCategoriesPointUseCase {
    var fetcherDTOs: [any DTODescriptionCategoriesPoint] { get }
    var didChangeContent: (([any DTODescriptionCategoriesPoint]) -> Void)? { get set }
    func startHandle()
}

protocol CategoriesPointWorkerUseCase {
    typealias CompletionHandler = (Bool) -> Void
    func deleteByUser(dto: (any DTODescriptionCategoriesPoint), completion: CompletionHandler?)
    func createPredefinedDTO()
    
}

final class CategoriesPointVM: CategoriesPointViewModelProtocol {

    private let adapter: CategoriesPointAdapterProtocol
    private var frcService: CategoriesPointFRCServiceCategoriesPointUseCase
    private var dataWorker: CategoriesPointWorkerUseCase
    private weak var coordinator: CategoriesPointCoordinatorProtocol?

    private var selectedDTO: (any DTODescriptionCategoriesPoint)?
    private var selectedIndexPath: IndexPath?

    typealias CompletionHandler = (_ action: CategoriesPointMenuAction) -> Void
    var didChangeMenuAction: CompletionHandler?
    
    init(frcService: CategoriesPointFRCServiceCategoriesPointUseCase,
         dataWorker: CategoriesPointWorkerUseCase,
         adapter: CategoriesPointAdapterProtocol,
         coordinator: CategoriesPointCoordinatorProtocol
    ) {
        self.frcService = frcService
        self.dataWorker = dataWorker
        self.adapter = adapter
        self.coordinator = coordinator

        bind()
    }
    
    private func bind() {
        frcService.didChangeContent = { [weak self] _ in
            let dtos = self?.frcService.fetcherDTOs
            self?.adapter.reloadData(dtos ?? [])
        }
        self.didChangeMenuAction = { [weak self] action in
            switch action {
            case .delete:
                
                if let dto = self?.selectedDTO {
                    self?.dataWorker.deleteByUser(dto: dto) { [weak self] isSuccess in
                        guard isSuccess else { return }

                        if isSuccess {
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(
                                    name: .updateCategory,
                                    object: nil
                                )
                            }
                        }
                    }
                }
                return
                
            case .edit:
                if let dto = self?.selectedDTO {
                    self?.coordinator?.openEditCategoriesPoint(dto: dto)
                }
                return
            default:
                return
            }
        }
        adapter.tapButtonOnDTO = { [weak self] dto, indexPath in
            guard let self else { return }
            self.selectedDTO = dto
            self.selectedIndexPath = indexPath
            self.coordinator?.showMenu(dto: dto, completion: didChangeMenuAction)
        }
    }

    func viewDidLoad() {
        frcService.startHandle()
        let dtos = frcService.fetcherDTOs
        if dtos.isEmpty {
            dataWorker.createPredefinedDTO()
        }
        adapter.reloadData(dtos)
    }
    
    func makeTableView() -> UITableView {
        return adapter.makeTableView()
    }

    func dismissDidTap() {
        coordinator?.finish()
    }
    
    func openEditCategoriesPoint() {
        self.coordinator?.openEditCategoriesPoint(dto: nil)
    }
}

extension Notification.Name {
    static let updateCategory = Notification.Name("updateCategory")
    static let updatePoint = Notification.Name("updatePoint")
}
