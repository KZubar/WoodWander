//
//  CreateCategoriesPointViewModelProtocol.swift
//  WoodWander
//
//  Created by k.zubar on 25.08.24.
//

import Foundation

@objc protocol CreateCategoriesPointViewModelProtocol: AnyObject {
    
    var catchNameError: ((String?) -> Void)? { get set }
    var catchDescrError: ((String?) -> Void)? { get set }

    var name: String? {get set}
    var descr: String? {get set}
    
    var color: String? {get set}
    var date: Date? {get set}
    var icon: String? {get set}
    var isDisabled: Bool {get set}
    var uuid: String? {get set}

    func dismissDidTap()
    func createDidTap()
}
