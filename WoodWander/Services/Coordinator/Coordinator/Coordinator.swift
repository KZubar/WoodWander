//
//  Coordinator.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit

class Coordinator {
    
    //FIXME: - проверить работу
    //{{
    enum ModuleIndex: Int {
        case planPoints = 1
        case factPoints = 2
        case settings = 3
        
//        //FIXME: - delete
//        case missions = 4
//        case camera = 5
//        case map = 6
    }
    
    weak var delegate: AppCoordinatorDelegate?
    
    func openModule( _ moduleIndex: ModuleIndex) {
        delegate?.openTab(moduleIndex.rawValue)
    }
    //}}
    
    var onDidFinish: ((Coordinator) -> Void)?
    
    var children: [Coordinator] = []
    
    var childrenMenu: [TabBarModule] = []

    func start() -> UIViewController {
        fatalError("Should be overriden")
    }

    func finish() {
        onDidFinish?(self)
    }
    
}

extension Coordinator: Equatable {
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
}
