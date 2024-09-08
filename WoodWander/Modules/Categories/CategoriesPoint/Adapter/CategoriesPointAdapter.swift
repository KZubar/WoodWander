//
//  CategoriesPointAdapter.swift
//  WoodWander
//
//  Created by k.zubar on 21.08.24.
//

import UIKit
import Storage

final class CategoriesPointAdapter: NSObject {
    
    private enum Const {
        static let HeaderViewHeight: Double = 32.0
    }
    
    var sections: [CategoriesPointSections] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var tapButtonOnDTO: ((_ dto: (any DTODescriptionCategoriesPoint)?,
                          _ indexPath: IndexPath) -> Void)?

    private lazy var tableHeaderView: CategoriesPointHeadView = {
        let frame = CGRect(x: .zero,
                           y: .zero,
                           width: .zero,
                           height: Const.HeaderViewHeight)
        let headerView = CategoriesPointHeadView(frame: frame)
        return headerView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.allowsSelection = false
        tableView.backgroundColor = .systemGray3 //FIXME: - установить цвет
        
        tableView.layer.cornerRadius = 10.0
        tableView.layer.borderWidth = 1.0
        tableView.layer.borderColor = UIColor.appWhite.cgColor //FIXME: - установить цвет

        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .appBlack
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        tableView.isScrollEnabled = true
        tableView.showsVerticalScrollIndicator = true
        tableView.tableHeaderView = tableHeaderView
        
        tableView.tableHeaderView = nil
        
        tableView.backgroundColor = .clear
        tableView.subviews.forEach { view in
            view.setShadow()
        }

        return tableView
    }()
    
    override init() {
        super.init()
        
        setupTableView()
        bind()
    }

    func bind() { }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CategoriesPointCell.self)
    }
    
}


extension CategoriesPointAdapter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        return section.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]

        switch section {
        case .predefined(let rows):
            let cell: CategoriesPointCell = tableView.dequeue(at: indexPath)
            cell.setupCell(rows[indexPath.row], indexPath: indexPath)
            cell.buttonDidTap = { [weak self] dto in
                self?.tapButtonOnDTO?(dto, indexPath)
            }

            return cell
        case .custom(let rows):
            let cell: CategoriesPointCell = tableView.dequeue(at: indexPath)
            cell.setupCell(rows[indexPath.row], indexPath: indexPath)
            cell.buttonDidTap = { [weak self] dto in
                self?.tapButtonOnDTO?(dto, indexPath)
            }
            return cell
        }
    }
    
    //пользовательский вид для верхнего колонтитула
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {        
        return nil
        
//        let sectionHeader = sections[section]
//        let header = CategoriesPointHeadView()
//        header.headerText = sectionHeader.headerText
//        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        8
    }
    
    //настраиваемый вид нижнего колонтитула. высота нижнего колонтитула будет установлена по умолчанию или указана отдельно
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    //высота нижнего колонтитула
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}



extension CategoriesPointAdapter: UITableViewDelegate { }

extension CategoriesPointAdapter: CategoriesPointAdapterProtocol {
    
    func makeTableView() -> UITableView {
        return self.tableView
    }
    
    func reloadData(_ dtos: [any DTODescriptionCategoriesPoint]) {
        
        let categoriesPointDtos = dtos.compactMap { dto in
            if let categoriesPointDTO = dto as? CategoriesPointDTO {
                return categoriesPointDTO
            } else { return nil}
        }
        
        let dtoPredefined = categoriesPointDtos
            .compactMap { if $0.predefined  == true { return $0 } else { return nil } }
        let dtoCustom = categoriesPointDtos
            .compactMap { if $0.predefined == false { return $0 } else { return nil } }

        self.sections = [
            .predefined(dtoPredefined),
            .custom(dtoCustom)
        ]
        self.tableView.subviews.forEach { view in
            view.setShadow()
        }

    }

}
