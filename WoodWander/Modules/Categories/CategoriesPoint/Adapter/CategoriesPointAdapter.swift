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
    
    var dtos: [any DTODescriptionCategoriesPoint] = [] {
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
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.keyboardDismissMode = .onDrag
        

        tableView.cornerRadius = 10.0
        tableView.setBorder(width: 1.0, color: .appWhite) //FIXME: - установить цвет

        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .appBlack
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        tableView.isScrollEnabled = true
        tableView.showsVerticalScrollIndicator = false
        //tableView.tableHeaderView = tableHeaderView
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dtos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let dto = dtos[indexPath.row] as? CategoriesPointDTO
        else { return .init() }
        
        let cell: CategoriesPointCell = tableView.dequeue(at: indexPath)
        cell.setupCell(dto, indexPath: indexPath)
        cell.buttonDidTap = { [weak self] dto in
            self?.tapButtonOnDTO?(dto, indexPath)
        }
        return cell
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
        self.dtos = dtos
        self.tableView.subviews.forEach { view in
            view.setShadow()
        }

    }

}
