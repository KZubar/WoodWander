//
//  CategoriesPointViewModelProtocol.swift
//  WoodWander
//
//  Created by k.zubar on 21.08.24.
//

import UIKit

protocol CategoriesPointViewModelProtocol {
    
    func viewDidLoad()
    func makeTableView() -> UITableView
    
//    func dismissDidTap()
    func openEditCategoriesPoint()
    
}

