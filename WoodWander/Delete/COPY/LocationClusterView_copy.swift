////
////  LocationClusterView.swift
////  NoteMe
////
////  Created by k.zubar on 27.06.24.
////
//
//import MapKit
//
//class LocationClusterView: MKAnnotationView {
//
//    private enum Const {
//        static let rectWidth: Double = 50.0
//        static let rectHeight: Double = 50.0
//        static let circRadius: Double = 25.0
//        static let fontSize: Double = 16.0
//        static let centerOffset: CGPoint = CGPoint(x: 0, y: -30)
//        static let sizeRenderer: CGSize = CGSize(width: rectWidth, height: rectHeight)
//    }
//
//    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
//        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        
//        //Приоритет отображения в представлении аннотаций.
//        displayPriority = .defaultHigh
//        
//        //Режим коллизии, используемый при интерпретации прямоугольника рамки коллизии.
//        collisionMode = .none
//        
//        //Смещение (в точках), с которым будет отображаться вид.
//        centerOffset = Const.centerOffset
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//    }
//
//    override var annotation: MKAnnotation? {
//        willSet {
//            guard let cluster = newValue as? MKClusterAnnotation else { return }
//            
//            let renderer = UIGraphicsImageRenderer(size: Const.sizeRenderer)
//            let count = cluster.memberAnnotations.count
//                        
//            image = renderer.image { _ in
//                
//                UIColor.appYellowAlpha.setFill()
//                let circlePath1 = circlePath(x: 0.0,
//                                             y: 0.0,
//                                             width: Const.rectWidth,
//                                             height: Const.rectHeight,
//                                             radius: Const.circRadius)
//                circlePath1.fill()
//                
//                UIColor.black.setStroke() //FIXME: UIColor.appBlack.setStroke()
//                circlePath1.stroke()
//                
//                let attributes =
//                [
//                    NSAttributedString.Key.foregroundColor: UIColor.black, //FIXME: UIColor.appBlack
//                    NSAttributedString.Key.font: UIFont.appBoldFont.withSize(Const.fontSize)
//                ]
//                
//                let text = "\(count)"
//                let size = text.size(withAttributes: attributes)
//                
//                let w = size.width
//                let h = size.height
//                let x = (Const.rectWidth - w) / 2
//                let y = (Const.rectHeight - h) / 2
//                let rect = CGRect(x: x, y: y, width: w, height: h)
//
//                text.draw(in: rect, withAttributes: attributes)
//            }
//            
//        }
//    }
//    
//    private func circlePath(x: Double,
//                            y: Double,
//                            width: Double,
//                            height: Double,
//                            radius: Double
//    ) -> UIBezierPath {
//        let rect = CGRect(x: x, y: y, width: width, height: height)
//        let circlePath = UIBezierPath(roundedRect: rect, cornerRadius: radius)
//        return circlePath
//    }
//
//}
