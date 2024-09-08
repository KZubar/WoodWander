////
////  LocationPinView.swift
////  WoodWander
////
////  Created by k.zubar on 27.06.24.
////
//
//import MapKit
//import SnapKit
//
//final class LocationPinView: MKAnnotationView {
//    
//    private lazy var imageView: UIImageView = {
//        let imgView = UIImageView(image: .Map.mappin)
//        imgView.contentMode = .scaleAspectFit
//        imgView.translatesAutoresizingMaskIntoConstraints = false
//        return imgView
//    }()
//    
//    override var isSelected: Bool {
//        didSet {
//            if isSelected {
//                UIView.animate(withDuration: 0.10) {
//                    self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//                }
//            } else {
//                UIView.animate(withDuration: 0.10) {
//                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                }
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
//        commonInit()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func commonInit() {
//        /////frame.size = .init(width: 45.0, height: 90.0)
//        frame.size = .init(width: 30.0, height: 30.0)
//
//        addSubview(imageView)
//        
//        imageView.snp.makeConstraints { make in
//            make.bottom.equalTo(self.snp.centerY)
//            make.top.equalTo(self.snp.top)
//            make.left.equalTo(self.snp.left)
//            make.right.equalTo(self.snp.right)
//        }
//    }
//    
//}
