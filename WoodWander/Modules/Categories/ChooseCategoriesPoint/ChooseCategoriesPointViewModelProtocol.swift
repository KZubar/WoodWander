//
//  ChooseCategoriesPointViewModelProtocol.swift
//  WoodWander
//
//  Created by k.zubar on 27.08.24.
//

import UIKit

protocol ChooseCategoriesPointViewModelProtocol {
    
    var point: PlanPointDescription { get set }
    var modified: Bool { get }

    func viewDidLoad()
    func makeTableView() -> UITableView
    
    func dismissDidTap()
    func saveDidTap()
    func openEditCategoriesPoint()
    
}

