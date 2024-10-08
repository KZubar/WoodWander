//
//  Collection+Register.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit
import MapKit

extension UITableView {
    
    func register<CellType: UITableViewCell>(_ type: CellType.Type) {
        self.register(CellType.self, forCellReuseIdentifier: "\(CellType.self)")
    }
    
    func dequeue<CellType: UITableViewCell>(at indexPath: IndexPath) -> CellType {
        return self.dequeueReusableCell(withIdentifier: "\(CellType.self)",
                                        for: indexPath) as! CellType
    }
    
}

extension UICollectionView {
    
    func register<CellType: UICollectionViewCell>(_ type: CellType.Type) {
        self.register(CellType.self, forCellWithReuseIdentifier: "\(CellType.self)")
    }
    
    func dequeue<CellType: UICollectionViewCell>(at indexPath: IndexPath) -> CellType {
        return self.dequeueReusableCell(withReuseIdentifier: "\(CellType.self)",
                                        for: indexPath) as! CellType
    }
    
}

extension MKMapView {
    
    func dequeue<AnnotationViewType: MKAnnotationView>() -> AnnotationViewType {
        return self.dequeueReusableAnnotationView(withIdentifier: "\(AnnotationViewType.self)") as! AnnotationViewType
    }
    
}
