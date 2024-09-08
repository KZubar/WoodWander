//
//  LocationClusterView.swift
//  NoteMe
//
//  Created by k.zubar on 27.06.24.
//

import MapKit

class LocationClusterView: MKAnnotationView {

//    private enum Const {
//        static let rectWidth: Double = 50.0
//        static let rectHeight: Double = 50.0
//        static let circRadius: Double = 25.0
//        static let fontSize: Double = 16.0
//        static let centerOffset: CGPoint = CGPoint(x: 0, y: -30)
//        static let sizeRenderer: CGSize = CGSize(width: rectWidth, height: rectHeight)
//    }
//
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        //Приоритет отображения в представлении аннотаций.
        displayPriority = .defaultHigh
        
        //Режим коллизии, используемый при интерпретации прямоугольника рамки коллизии.
        collisionMode = .none
        
//        //Смещение (в точках), с которым будет отображаться вид.
//        centerOffset = Const.centerOffset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override var annotation: MKAnnotation? {
        willSet {
//            guard let cluster = newValue as? MKClusterAnnotation else { return }
//            
//            displayPriority = .defaultLow//defaultHigh
//
//            //let count = cluster.memberAnnotations.count
//                        
//            image = .Map.mappin
        }
    }
    
}
