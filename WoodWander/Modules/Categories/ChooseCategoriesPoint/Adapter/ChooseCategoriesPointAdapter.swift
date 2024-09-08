//
//  ChooseCategoriesPointAdapter.swift
//  WoodWander
//
//  Created by k.zubar on 27.08.24.
//

import UIKit
import Storage

final class ChooseCategoriesPointAdapter: NSObject {
    
    private enum Const {
        static let HeaderViewHeight: Double = 32.0
    }
    
    private var sections: [ChooseCategoriesPointSections] = [.predefined, .custom]
    
    private var dtosPredefined: [any DTODescriptionCategoriesPoint] = []
    private var dtosCustom: [any DTODescriptionCategoriesPoint] = []
    private var dictCheck: [String: Bool] = [:]

    var tapButtonOnDTO: ((_ dto: (any DTODescriptionCategoriesPoint)?,
                          _ check: Bool,
                          _ indexPath: IndexPath) -> Void)?
    
    var descrTextViewDidChangeHandle: ((_ dto: (any DTODescriptionCategoriesPoint)?,
                                        _ descr: String?) -> Void)?

    private lazy var tableHeaderView: ChooseCategoriesPointHeadView = {
        let frame = CGRect(x: .zero,
                           y: .zero,
                           width: .zero,
                           height: Const.HeaderViewHeight)
        let headerView = ChooseCategoriesPointHeadView(frame: frame)
        return headerView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.allowsSelection = false
        tableView.backgroundColor = .systemGray3 //FIXME: - установить цвет
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.keyboardDismissMode = .onDrag
        
        tableView.cornerRadius = 10.0
        tableView.setBorder(width: 1.0, color: .appWhite) //FIXME: - установить цвет

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
        
        tableView.register(ChooseCategoriesPointCell.self)
    }
    

}

extension ChooseCategoriesPointAdapter: UITableViewDelegate { }

extension ChooseCategoriesPointAdapter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .predefined:
            return self.dtosPredefined.count
        case .custom:
            return self.dtosCustom.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]

        var dto: (any DTODescriptionCategoriesPoint)
        
        switch section {
        case .predefined:
            dto = dtosPredefined[indexPath.row]
        case .custom:
            dto = dtosCustom[indexPath.row]
        }
        
        let cell: ChooseCategoriesPointCell = tableView.dequeue(at: indexPath)
        let check: Bool = dictCheck[dto.uuid] ?? false
        cell.setupCell(dto, check: check, indexPath: indexPath)
        cell.buttonDidTap = { [weak self] dto, check in
            self?.tapButtonOnDTO?(dto, check, indexPath)
        }
        cell.delegate = self
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        
        return cell
    }
    
    //пользовательский вид для верхнего колонтитула
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return nil
        
//        let sectionHeader = sections[section]
//        let header = ChooseCategoriesPointHeadView()
//        header.headerText = sectionHeader.headerText
//        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    //настраиваемый вид нижнего колонтитула. высота нижнего колонтитула будет установлена по умолчанию или указана отдельно
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    //устанавливает высоту ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //высота нижнего колонтитула
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension ChooseCategoriesPointAdapter: ChooseCategoriesPointCellProtocol {
    
    func descrTextViewDidChange(dto: (any DTODescriptionCategoriesPoint)?,
                                descr: String?) {
        self.descrTextViewDidChangeHandle?(dto, descr)
    }
    
    func tableViewUpdates() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension ChooseCategoriesPointAdapter: ChooseCategoriesPointAdapterProtocol {
    
    func makeTableView() -> UITableView {
        return self.tableView
    }
    
    func reloadData(dtosPredefined: [any DTODescriptionCategoriesPoint],
                    dtosCustom: [any DTODescriptionCategoriesPoint],
                    dictCheck: [String: Bool]) {

        self.dtosPredefined = dtosPredefined
        self.dtosCustom = dtosCustom
        self.dictCheck = dictCheck

        tableView.reloadData()
        
        self.tableView.subviews.forEach { view in
            view.setShadow()
        }

    }

}

