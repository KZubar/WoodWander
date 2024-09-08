////
////  LocationMarkerView.swift
////  NoteMe
////
////  Created by k.zubar on 27.06.24.
////
//
//import MapKit
//import UIKit
//import SnapKit
//
//class LocationMarkerView: MKMarkerAnnotationView {
//    
////    private lazy var imageView: UIImageView = {
////        let imgView = UIImageView(image: .Map.mappinAndEllipse)
////        imgView.contentMode = .scaleAspectFit
////        imgView.translatesAutoresizingMaskIntoConstraints = false
////        return imgView
////    }()
//        
//    override var isSelected: Bool {
//        didSet {
////            setSelected(isSelected, animated: false)
////            if isSelected {
////                UIView.animate(withDuration: 0.15) {
////                    self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
////                }
////            } else {
////                UIView.animate(withDuration: 0.15) {
////                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
////                }
////            }
//        }
//    }
//
//    override var annotation: MKAnnotation? {
//        willSet {
//            if newValue is LocationPin {
//                
//                frame.size = .init(width: 45.0, height: 45.0)
//
//                clusteringIdentifier = "locationPin"
//
//                titleVisibility = .hidden
//                subtitleVisibility = .hidden
//                
//
//                //Текст вместо изображения
//                //glyphText = "text"
//                
//                //отображать доп инфо
//                canShowCallout = false
//                
//                //кнопка справа
//                //rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//                
//                //цвет картинки
//                markerTintColor = .gradient0.withAlphaComponent(1.0)
//                
//                //Цвет, текста или изображению глифа.
//                glyphTintColor = .gradient2
//                                
//                //картинка
//                glyphImage = .Map.mappin
//                
//                //приоритет отображения
//                displayPriority = .defaultHigh
//                
//                //разрешить перетаскивание
//                isDraggable = true
//                
//                //будет ли маркер анимирован в нужном положении на экране.
//                animatesWhenAdded = false
//                
//            }
//        }
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//    }
//    
//    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
//        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        //print("\(frame.size)")
//        commonInit()
//        //print("\(frame.size)")
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func commonInit() {
////        /////frame.size = .init(width: 45.0, height: 90.0)
////        frame.size = .init(width: 45.0, height: 45.0)
////
////        addSubview(imageView)
////
////        imageView.snp.makeConstraints { make in
////            make.bottom.equalTo(self.snp.centerY)
////            make.top.equalTo(self.snp.top)
////            make.left.equalTo(self.snp.left)
////            make.right.equalTo(self.snp.right)
////        }
//    }
//
//
//}
